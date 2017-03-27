/**
 * @class PackageSet
 * A set of Node.js package expressions that can be deployed with the Nix
 * package manager.
 */
var fs = require('fs');
var path = require('path');
var url = require('url');
var slasp = require('slasp');
var nijs = require('nijs');
var semver = require('semver');

var fetchMetaDataFromNPMRegistry = require('./packagefetcher/npmregistry.js').fetchMetaDataFromNPMRegistry;
var fetchMetaDataFromGit = require('./packagefetcher/git.js').fetchMetaDataFromGit;
var fetchMetaDataFromHTTP = require('./packagefetcher/http.js').fetchMetaDataFromHTTP;
var fetchMetaDataFromLocalDirectory = require('./packagefetcher/local.js').fetchMetaDataFromLocalDirectory;

/**
 * @constructor
 * Constructs a Nix expression for a set of Node.js packages that can be deployed
 * with the Nix package manager.
 *
 * @param {String} registryURL URL of the NPM registry
 * @param {String} outputDir Directory in which the generated Nix expressions will be written
 */
function PackageSet(registryURL, outputDir) {
    this.registryURL = registryURL;
    this.outputDir = outputDir;
    this.sources = {};
}

function composeGitURL(baseURL, parsedUrl) {
    var hashComponent;
    
    if(parsedUrl.hash === null)
        hashComponent = "";
    else
        hashComponent = parsedUrl.hash;
        
    return baseURL + "/" + parsedUrl.host + parsedUrl.path + hashComponent;
}

/**
 * Fetches package metadata from an external source that is determined by the
 * version specifier, so that a partial Nix expression can be generated that
 * deploys it as a dependency.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} dependencyName Name of a Node.js package
 * @param {String} versionSpec Version specifier of a Node.js package, such as
 *     an exact version number, version range, URL, or GitHub identifier
 * @param {function(String, Object)} callback Callback function that gets
 *     invoked when the work is done.
 *     If an error occured, the first parameter is set to the corresponding error message.
 *     If the operation succeeded, a metadata object is returned containing an
 *     identifier for the package (that will be used in the generated attribute
 *     set to refer to it), packageObj package.json object, and a src
 *     corresponding to a Nix function invocation that fetches the package from
 *     an external source
 */
PackageSet.prototype.fetchMetaData = function(baseDir, dependencyName, versionSpec, callback) {

    var parsedVersionSpec = semver.validRange(versionSpec, true);
    var parsedUrl = url.parse(versionSpec);

    if(parsedVersionSpec !== null) { // If the version is valid semver range, fetch the package from the NPM registry
        fetchMetaDataFromNPMRegistry(baseDir, dependencyName, parsedVersionSpec, this.registryURL, callback);
    } else if(parsedUrl.protocol == "github:") { // If the version is a GitHub repository, compose the corresponding Git URL and do a Git checkout
        fetchMetaDataFromGit(baseDir, dependencyName, composeGitURL("git://github.com", parsedUrl), callback);
    } else if(parsedUrl.protocol == "gist:") { // If the version is a GitHub gist repository, compose the corresponding Git URL and do a Git checkout
        fetchMetaDataFromGit(baseDir, dependencyName, composeGitURL("https://gist.github.com", parsedUrl), callback);
    } else if(parsedUrl.protocol == "bitbucket:") { // If the version is a Bitbucket repository, compose the corresponding Git URL and do a Git checkout
        fetchMetaDataFromGit(baseDir, dependencyName, composeGitURL("git://bitbucket.org", parsedUrl), callback);
    } else if(parsedUrl.protocol == "gitlab:") { // If the version is a Gitlab repository, compose the corresponding Git URL and do a Git checkout
        fetchMetaDataFromGit(baseDir, dependencyName, composeGitURL("git://gitlab.com", parsedUrl), callback);
    } else if(typeof parsedUrl.protocol == "string" && parsedUrl.protocol.substr(0, 3) == "git") { // If the version is a Git URL do a Git checkout
        fetchMetaDataFromGit(baseDir, dependencyName, versionSpec, callback);
    } else if(parsedUrl.protocol == "http:" || parsedUrl.protocol == "https:") { // If the version is an HTTP URL do a download
        fetchMetaDataFromHTTP(baseDir, dependencyName, versionSpec, callback);
    } else if(versionSpec.match(/^[a-zA-Z0-9_\-]+\/[a-zA-Z0-9]+[#[a-zA-Z0-9_\-]+]?$/)) { // If the version is a GitHub repository, compose the corresponding Git URL and do a Git checkout
        fetchMetaDataFromGit(baseDir, dependencyName, "git://github.com/"+versionSpec, callback);
    } else if(parsedUrl.protocol == "file:") { // If the version is a file URL, simply compose a Nix path
        fetchMetaDataFromLocalDirectory(baseDir, this.outputDir, parsedUrl.path, callback);
    } else if(versionSpec.substr(0, 3) == "../" || versionSpec.substr(0, 2) == "~/" || versionSpec.substr(0, 2) == "./" || versionSpec.substr(0, 1) == "/") { // If the version is a path, simply compose a Nix path
        fetchMetaDataFromLocalDirectory(baseDir, this.outputDir, versionSpec, callback);
    } else { // In all other cases, just try the registry. Sometimes invalid semver ranges are encountered or a tag has been provided (e.g. 'latest', 'unstable')
        fetchMetaDataFromNPMRegistry(baseDir, dependencyName, versionSpec, this.registryURL, callback);
    }
};

/**
 * Checks if any parent package provides a dependency corresponding to given
 * dependency name and version specification returns it corresponding metadata.
 *
 * @param {Object} metadata A package metadata object that contains the package configuration and link to the parent that includes it
 * @param {String} dependencyName Name of a Node.js package
 * @param {String} versionSpec Version specifier of a Node.js package, such as
 *     an exact version number, version range, URL, or GitHub identifier
 * @return {Object} The parent dependency metadata conforming to the requested version specifier or null if none exists
 */
PackageSet.prototype.findConformantParent = function(metadata, dependencyName, versionSpec) {
    if(metadata === null || metadata === undefined) { // If we have reached a leaf of the dependency graph, we know there are no dependencies
        return null;
    } else if(metadata.resolvedDependencies === undefined) {
        return null;
    } else {
        var resolvedDependency = metadata.resolvedDependencies[dependencyName];
        
        if(resolvedDependency === undefined) { // If the parent does not provide a package with the dependency name, consult the parent's parent
            return this.findConformantParent(metadata.parent, dependencyName, versionSpec);
        } else { // If the parent provides the package with the same name, check if the version satifies. If so => the parent provides it so that we do not have to include it again. Otherwise, it conflicts.
            if(semver.satisfies(resolvedDependency.packageObj.version, versionSpec, true)) {
                return resolvedDependency;
            } else {
                return null;
            }
        }
    }
};

/**
 * Checks whether the dependency conflicts when it binds to a package.
 *
 * @param {String} property Which property to check: either resolvedDependencies or boundDependenices
 * @param {Object} metadata Metadata of the package to bind a dependency to
 * @param {Object} dependencyMetadata Metadata data of a dependency package
 * @return {Boolean} true if the package conflicts, else false
 */
PackageSet.prototype.hasConflict = function(property, metadata, dependencyMetadata) {
    if(metadata.parent === null || metadata.parent === undefined) {
        return true;
    } else if(metadata.parent[property] === undefined) {
        return false;
    } else {
        var dependency = metadata.parent[property][dependencyMetadata.packageObj.name];
        
        if(dependency === undefined) {
            return false;
        } else {
            return dependency.packageObj.version !== dependencyMetadata.packageObj.version;
        }
    }
};

/**
 * Binds a package as a dependency to another package. If the flatten option has
 * been enabled, then it will attempt to bind the dependency as high in the
 * directory structure as possible.
 *
 * @param {Object} metadata Metadata of the package to bind a dependency to
 * @param {Object} dependencyMetadata Metadata data of a dependency package
 * @param {Boolean} flatten Whether to bind to dependency as high as possible in the directory structure
 */
PackageSet.prototype.bindDependency = function(metadata, dependencyMetadata, flatten) {
    if(metadata.boundDependencies !== null) {
        // Bind the package to the given dependency
        if(metadata.boundDependencies === undefined) {
            metadata.boundDependencies = {};
        }
        
        metadata.boundDependencies[dependencyMetadata.packageObj.name] = dependencyMetadata;
    
        if(!flatten || (this.hasConflict("resolvedDependencies", metadata, dependencyMetadata) || this.hasConflict("boundDependencies", metadata, dependencyMetadata))) {
            // Set the dependency's parent to the includer
            dependencyMetadata.parent = metadata;
            
            // Add the dependencies to the object of resolved dependencies that will be returned later
            if(metadata.resolvedDependencies === undefined) {
                metadata.resolvedDependencies = {};
            }
            
            metadata.resolvedDependencies[dependencyMetadata.packageObj.name] = dependencyMetadata;
            
            // Add the resolved dependency to the source cache so that they only appear once in the generated expression
            this.sources[dependencyMetadata.identifier] = dependencyMetadata;
        } else {
            this.bindDependency(metadata.parent, dependencyMetadata, flatten);
        }
    }
};

function isBundledDependency(metadata, dependencyName) {
    if(metadata !== null) {
        if(Array.isArray(metadata.bundledDependencies)) {
            for(var i = 0; i < metadata.bundledDependencies.length; i++) {
                if(dependencyName == metadata.bundledDependencies[i])
                    return true;
            }
        }
        
        if(Array.isArray(metadata.bundleDependencies)) {
            for(var i = 0; i < metadata.bundleDependencies.length; i++) {
                if(dependencyName == metadata.bundleDependencies[i])
                    return true;
            }
        }
    }
    
    return false;
}

/**
 * Generates metadata objects for a set of dependencies of a package containing
 * the exact versions that will be used.
 *
 * @param {Object} resolvedDependencies An object in which each key corresponds to the name of a resolved package and each value to the corresponding metadata
 * @param {Object} metadata Metadata object of the package that we request the dependencies from or null if we just want to deploy an arbitrary set of packages
 * @param {Object} dependencies An object in which every key represents a package name and each value a version specification.
 * @param {Boolean} flatten Indicates whether to create a flat dependency structure in which dependencies are as high as possible in the graph
 * @param {function(String, Object)} callback Callback that gets invoked when the work is done.
 *     If an error occured, the error parameter is set to contain an error message
 */
PackageSet.prototype.resolveDependencies = function(resolvedDependencies, metadata, dependencies, flatten, callback) {
    var self = this;
    
    if(typeof dependencies == "object" && dependencies !== null) { // If the dependency set is empty then we don't have to generate anything
        
        slasp.fromEach(function(callback) {
            callback(null, dependencies);
        }, function(dependencyName, callback) {
            var versionSpec = dependencies[dependencyName];
            
            if(isBundledDependency(metadata, dependencyName)) { // Only include dependencies that are not bundled
                callback();
            } else {
                var parentDependency = self.findConformantParent(metadata.parent, dependencyName, versionSpec);
            
                if(parentDependency === null) { // Only include a dependency, if none of the parents can provide the package that matches the version specifier
                    slasp.sequence([
                        function(callback) {
                            // Fetch package meta data from an external source
                            self.fetchMetaData(metadata.baseDir, dependencyName, versionSpec, callback);
                        },
                    
                        function(callback, dependencyMetadata) {
                            // Add the dependency to the array that will be returned later
                            resolvedDependencies[dependencyMetadata.packageObj.name] = dependencyMetadata;
                            
                            // Bind the dependency to the package (and optionally add it as high as possible in the directory structure)
                            self.bindDependency(metadata, dependencyMetadata, flatten);
                            callback();
                        }
                    ], callback);
                } else {
                    // Bind metadata to the parent dependency that satisfies the version specifier
                    if(metadata.boundDependencies === undefined) {
                        metadata.boundDependencies = {};
                    }
                    
                    metadata.boundDependencies[parentDependency.packageObj.name] = parentDependency;
                    
                    callback();
                }
            }
        }, callback);
    } else {
        callback();
    }
};

/**
 * Generates a tree of metadata objects for all requested transitive
 * dependencies of a package containing the exact versions that will be used and
 * appends it to the given metadata object through the resolvedDependencies
 * property.
 *
 * @param {Object} metadata Metadata object of the package that we request the dependencies from or null if we just want to deploy an arbitrary set of packages
 * @param {Boolean} production Indicates whether we deploy in production mode or development mode. In development mode, also the development dependencies will be included.
 * @param {Boolean} includePeerDependencies Indicates whether the peer dependencies should be included.
 * @param {Boolean} flatten Indicates whether to create a flat dependency structure in which dependencies are as high as possible in the graph
 * @param {function(String)} callback allback Callback that gets invoked when the work is done.
 *     If an error occured, the error parameter is set to contain an error message.
 */
PackageSet.prototype.resolveAllDependencies = function(metadata, production, includePeerDependencies, flatten, callback) {
    var self = this;
    var resolvedDependencies = {};
    
    slasp.sequence([
        function(callback) {
            self.resolveDependencies(resolvedDependencies, metadata, metadata.packageObj.dependencies, flatten, callback);
        },
        
        function(callback) {
            /* Resolve the development dependencies, if applicable */
            if(production) {
                callback();
            } else {
                self.resolveDependencies(resolvedDependencies, metadata, metadata.packageObj.devDependencies, flatten, callback);
            }
        },
        
        function(callback) {
            /* Resolve the peer dependencies, if applicable */
            if(includePeerDependencies) {
                self.resolveDependencies(resolvedDependencies, metadata, metadata.packageObj.peerDependencies, flatten, callback);
            } else {
                callback();
            }
        },
        
        function(callback) {
            /* Recursively resolve all transitive dependencies */
            
            slasp.fromEach(function(callback) {
                callback(null, resolvedDependencies);
            }, function(dependencyName, callback) {
                var resolvedDependency = resolvedDependencies[dependencyName];
                
                self.resolveAllDependencies(resolvedDependency, true /* Never include development dependencies of transitive dependencies */, includePeerDependencies, flatten, callback);
            }, callback);
        }
    ], callback);
}

/**
 * Generates a Nix attribute set in which each key refers to a package with a
 * certain version specifier and each value to a set of properties that specify
 * how to obtain it from an external source.
 *
 * @return {Object} An object containing references to all sources
 */
PackageSet.prototype.generateSourcesExpr = function() {
    var sources = {};
    
    for(var identifier in this.sources) {
        var source = this.sources[identifier];
        
        sources[identifier] = {
            name: source.packageObj.name,
            packageName: source.packageObj.name,
            version: source.packageObj.version,
            src: source.src
        }
    }
    
    return sources;
};

/**
 * Generates a Nix list in which each element refer to a dependency that a
 * package needs.
 *
 * @param {Object} metadata An object containing the metadata of a package including its resolved dependencies
 * @return {Array} A list of attribute set references to the sources and its transitive dependencies
 */
PackageSet.prototype.generateDependencyListExpr = function(metadata) {
    var dependencies = [];
    
    for(var dependencyName in metadata.resolvedDependencies) {
        var resolvedDependency = metadata.resolvedDependencies[dependencyName];
        
        // For each dependency, refer to the source attribute set that defines it
        var ref = new nijs.NixAttrReference({
            attrSetExpr: new nijs.NixExpression("sources"),
            refExpr: resolvedDependency.identifier
        });
        
        var packageDependencies = this.generateDependencyListExpr(resolvedDependency);
        var dependencyExpr;
        
        if(packageDependencies === undefined) {
            dependencyExpr = ref; // If a dependency has no dependencies of its own, we just refer to the attribute in the source set
        } else {
            // If a dependency has dependencies, we augment the reference with the set of dependencies that it needs
            dependencyExpr = new nijs.NixMergeAttrs({
                left: ref,
                right: {
                    dependencies: packageDependencies
                }
            });
        }
        
        dependencies.push(dependencyExpr);
    }
    
    if(dependencies.length == 0) {
        return undefined; // If no dependencies are required, simply compose no parameter. Though not mandatory, it improves readability of the generated expression
    } else {
        return dependencies;
    }
};

/**
 * Generates a Nix expression containing an attribute set providing parameters
 * to the Nix functions that deploy NPM packages.
 *
 * @param {Object} metadata Metadata of the package to deploy
 * @param {Boolean} production Indicates whether we deploy in production mode or development mode. In development mode, also the development dependencies will be included.
 * @param {Boolean} includePeerDependencies Indicates whether the peer dependencies should be included.
 * @param {Boolean} flatten Indicates whether to create a flat dependency structure in which dependencies are as high as possible in the graph
 * @param {function(String,Object)} callback Callback function that gets invoked when the work is done. The first parameter is set to an error message if some error occured.
 *     The second parameter is set to an object containing the parameters.
 */
PackageSet.prototype.generatePackageArgsExpr = function(metadata, production, includePeerDependencies, flatten, callback) {

    var self = this;

    slasp.sequence([
        function(callback) {
            self.resolveAllDependencies(metadata, production, includePeerDependencies, flatten, callback);
        },
        
        function(callback) {
            var dependencies = self.generateDependencyListExpr(metadata);
            
            /* Compose the function invocation that builds the Node.js package from the source and its dependencies */
            var homepage;
            
            if(typeof metadata.packageObj.homepage == "string" && metadata.packageObj.homepage) {
                homepage = new nijs.NixURL(metadata.packageObj.homepage);
            }
            
            callback(null, {
                name: metadata.packageObj.name.replace("@", "_at_").replace("/", "_slash_"), // Escape characters from scoped package names that aren't allowed
                packageName: metadata.packageObj.name,
                version: metadata.packageObj.version,
                src: metadata.src,
                dependencies: dependencies,
                buildInputs: new nijs.NixExpression("globalBuildInputs"),
                meta: {
                    description: metadata.packageObj.description,
                    homepage: homepage,
                    license: metadata.packageObj.license
                },
                production: production
            });
        }
    ], callback);
};

/**
 * Generates a package set expression function with a given body that refers to
 * a number of jobs and optionally an args object containing the parameters
 * passed to each build function.
 *
 * @param {Object} body An object in which the members invoke functions to build NPM packages
 * @param {Object} args An object representing the parameters passed to each build function or undefined
 * @return {NixFunction} A Nix function that can be composed to build NPM packages
 */
PackageSet.prototype.generatePackageSetFunctionExpr = function(body, args) {
    return new nijs.NixFunction({
        argSpec: {
            nodeEnv: undefined,
            fetchurl: undefined,
            fetchgit: undefined,
            globalBuildInputs: []
        },
        body: new nijs.NixLet({
            value: {
                sources: this.generateSourcesExpr(),
                args: args
            },
            body: body
        })
    });
};

exports.PackageSet = PackageSet;
