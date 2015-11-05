/**
 * @class Registry
 * A registry of Node.js package expressions that can be deployed with the Nix
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
 * Construct a registry of Node.js packages that can be deployed with the Nix
 * package manager.
 *
 * @param {String} registryURL URL of the NPM registry
 * @param {Boolean} linkDependencies Indicates whether to symlink the dependencies instead of copying them
 */
function Registry(registryURL, linkDependencies) {
    this.registryURL = registryURL;
    this.linkDependencies = linkDependencies;
    this.registryExpr = {};
    this.versionSpecCache = {};
}

/**
 * Adds a Node.js package and its dependency closure to the registry.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which generated nix expression will be written
 * @param {String} dependencyName Name of a Node.js package
 * @param {String} versionSpec Version specifier of a Node.js package, which can be an exact version number, version range, URL, or GitHub identifier
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occured, the first parameter is set to the corresponding error message.
 *     If the operation succeeded, the resolved exact version number of the package is returned through the second parameter.
 */
Registry.prototype.addDependencyClosure = function(baseDir, outputDir, dependencyName, versionSpec, callback) {

    if(this.versionSpecCache[dependencyName] === undefined || this.versionSpecCache[dependencyName][versionSpec] === undefined) { // If the resolved version is not cached, fetch it and determine the version
        var self = this;
        var parsedVersionSpec = semver.validRange(versionSpec);
        var parsedUrl = url.parse(versionSpec);
        var metadata;
        
        slasp.sequence([
            /* Consult an external source to obtain the metadata that is needed to build the package with Nix */
            function(callback) {
                if(parsedVersionSpec !== null) { // If the version is valid semver range, fetch the package from the NPM registry
                    fetchMetaDataFromNPMRegistry(dependencyName, parsedVersionSpec, self.registryURL, callback);
                } else if(parsedUrl.protocol == "github:") { // If the version is a GitHub repository, compose the corresponding Git URL and do a Git checkout
                    fetchMetaDataFromGit(dependencyName, "git://github.com/"+parsedUrl.host+parsedUrl.path, callback);
                } else if(typeof parsedUrl.protocol == "string" && parsedUrl.protocol.substr(0, 3) == "git") { // If the version is a git URL do a Git checkout
                    fetchMetaDataFromGit(dependencyName, versionSpec, callback);
                } else if(parsedUrl.protocol == "http:" || parsedUrl.protocol == "https:") { // If the version is an HTTP URL do a download
                    fetchMetaDataFromHTTP(dependencyName, versionSpec, callback);
                } else if(versionSpec.match(/^[a-zA-Z0-9_\-]+\/[a-zA-Z0-9]+[#[a-zA-Z0-9_\-]+]?$/)) { // If the version is a GitHub repository, compose the corresponding Git URL and do a Git checkout
                    fetchMetaDataFromGit(dependencyName, "git://github.com/"+versionSpec, callback);
                } else if(parsedUrl.protocol == "file:") { // If the version is a file URL, simply compose a Nix path
                    fetchMetaDataFromLocalDirectory(baseDir, outputDir, parsedUrl.path, callback);
                } else if(versionSpec.substr(0, 3) == "../" || versionSpec.substr(0, 2) == "~/" || versionSpec.substr(0, 2) == "./" || versionSpec.substr(0, 1) == "/") { // If the version is a path, simply compose a Nix path
                    fetchMetaDataFromLocalDirectory(baseDir, outputDir, versionSpec, callback);
                } else { // In all other cases, just try the registry. Sometimes invalid semver ranges are encountered or a tag has been provided (e.g. 'latest', 'unstable')
                    fetchMetaDataFromNPMRegistry(dependencyName, versionSpec, self.registryURL, callback);
                }
            },
            
            function(callback, _metadata) {
                /* Add resolved package to the cache to prevent this function consulting an external resource again */
                metadata = _metadata;
                
                var newBaseDir = metadata.baseDir || baseDir;

                if(self.versionSpecCache[dependencyName] === undefined)
                    self.versionSpecCache[dependencyName] = {};
                    
                self.versionSpecCache[dependencyName][versionSpec] = metadata.packageObj.version;

                /* Compose a package out of the retrieved source location and package configuration object */
                self.addPackage(newBaseDir, outputDir, metadata.packageObj, metadata.src, true, callback);
            },
            
            function(callback) {
                /*
                 * If the version specifier is not an exact version, add an alias
                 * to the registry so that the package can be addressed by its version specification as well.
                 */
                var aliasVersion;
                
                if(versionSpec == "latest" || versionSpec == "*" || versionSpec == "") { // For the latest version specifiers, it makes more sense to refer to it directly by package name
                    aliasVersion = "";
                } else {
                    aliasVersion = "-" + versionSpec; // Otherwise, use the version spec as a suffix for the alias
                }
                
                var aliasIdentifier = dependencyName + aliasVersion;
                
                if(self.registryExpr[aliasIdentifier] === undefined) {
                    self.registryExpr[aliasIdentifier] = new nijs.NixAttrReference({
                        attrSetExpr: new nijs.NixExpression("self"),
                        refExpr: dependencyName + "-" + metadata.packageObj.version
                    });
                }
                
                /* Return the exact resolved version number to the caller */
                callback(null, metadata.packageObj.version);
            }
        ], callback);
    } else {
        callback(null, this.versionSpecCache[dependencyName][versionSpec]); // The resolved version is cached. Return the result from the cache.
    }
};

/**
 * Generates the dependency parameters that are passed to the build function.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which generated nix expression will be written
 * @param {Object} dependencies An object in which every key represents a package name and each value a version specification.
 * @param {function(String, Object)} callback Callback that gets invoked when the work is done.
 *     If an error occured, the error parameter is set to contain an error message
 *     If the operation succeeded, an object is returned containing references to the dependencies including the version specifiers, actual version numbers and the Nix packages providing them
 */
Registry.prototype.generateDependencyFunArgs = function(baseDir, outputDir, dependencies, callback) {

    var self = this;
    
    if(typeof dependencies == "object" && dependencies !== null) {
        var dependencyInvocationsExpr = {};
        
        slasp.fromEach(function(callback) {
            callback(null, dependencies);
        }, function(dependencyName, callback) {
            var versionSpec = dependencies[dependencyName];
            
            slasp.sequence([
                /* Add the dependency closures of all dependencies defined in the package configuration */
                function(callback) {
                    self.addDependencyClosure(baseDir, outputDir, dependencyName, versionSpec, callback);
                },
                
                /* Compose the dependency parameters containing version specifiers, actual version number and Nix packages that implement them  */
                function(callback, version) {
                    dependencyInvocationsExpr[dependencyName] = {};
                    dependencyInvocationsExpr[dependencyName][versionSpec] = {
                        version: version,
                        pkg: new nijs.NixAttrReference({
                            attrSetExpr: new nijs.NixExpression("self"),
                            refExpr: dependencyName + "-" + version
                        })
                    };
                    
                    callback(null);
                }
            ], callback);
            
        }, function(err) {
            if(err)
                callback(err);
            else
                callback(null, dependencyInvocationsExpr);
        });
    }
    else
        callback();
};

/**
 * Adds a single package to the registry including all its dependencies.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {Object} packageObj Object representing the Node.js package configuration (typically provided through package.json)
 * @param {Object} src A Nix language object that retrieves the package from a local or external source
 * @param {Boolean} production A boolean that specifies whether to use production development or not. Non-production developments also install all devDependencies.
 * @param {function(String)} callback Callback function that gets invoked when the work is done. The first parameter is set to an error message if some error occured.
 */
Registry.prototype.addPackage = function(baseDir, outputDir, packageObj, src, production, callback) {

    var pkgIdentifier = packageObj.name + "-" + packageObj.version;
    
    if(this.registryExpr[pkgIdentifier] === undefined) { // Only generate expressions for packages that have not been added yet
    
        var self = this;
        
        /* Add null placeholder to the registry which prevents the package from
         * being generated a second time and that we might end up in an infinite
         * loop. Null gets replaced by the real expression later in the
         * generation process.
         */
        this.registryExpr[pkgIdentifier] = null;
        
        var allDependencies;

        slasp.sequence([
            function(callback) {
                /* Generate function arguments for the dependencies */
                self.generateDependencyFunArgs(baseDir, outputDir, packageObj.dependencies, callback);
            },
            
            function(callback, dependencies) {
                /* Generate function arguments for dev dependencies, if applicable */
                allDependencies = dependencies;
                
                if(production)
                    callback();
                else
                    self.generateDependencyFunArgs(baseDir, outputDir, packageObj.devDependencies, callback);
            },
            
            function(callback, devDependencies) {
                /* Merge the previous dependency arguments together */
                if(allDependencies === undefined)
                    allDependencies = devDependencies;
                else {
                    for(var dependencyName in devDependencies) {
                        allDependencies[dependencyName] = devDependencies[dependencyName];
                    }
                }
                
                self.generateDependencyFunArgs(baseDir, outputDir, packageObj.peerDependencies, callback);
            },
            
            function(callback, peerDependencies) {
                /* Merge the previous dependency arguments together */
                if(allDependencies === undefined)
                    allDependencies = peerDependencies;
                else {
                    for(var dependencyName in peerDependencies) {
                        allDependencies[dependencyName] = peerDependencies[dependencyName];
                    }
                }
                
                /* Compose the function invocation that builds the Node.js package from the source and its dependencies */
                var homepage;
                
                if(packageObj.homepage) {
                    if(packageObj.homepage && typeof packageObj.homepage == "string") {
                        homepage = new nijs.NixURL(packageObj.homepage);
                    }
                }
                
                var expr = new nijs.NixFunInvocation({
                    funExpr: new nijs.NixExpression("buildNodePackage"),
                    paramExpr: {
                        name: packageObj.name,
                        version: packageObj.version,
                        src: src,
                        dependencies: allDependencies,
                        meta: {
                            description: packageObj.description,
                            homepage: homepage,
                            license: packageObj.license
                        },
                        production: production,
                        linkDependencies: self.linkDependencies
                    }
                });
            
                /* Add the invocation to the registry */
                self.registryExpr[pkgIdentifier] = expr;
            
                callback(null);
            }
        ], callback);
    }
    else
        callback(null);
};

/**
 * Constructs the abstract syntax of the Nix expression representing the registry
 * of Node.js packages that can be deployed with Nix.
 *
 * @return {NixFunction} A Nix function that can be invoked to build Node.js packages
 */
Registry.prototype.toNixExpr = function() {
    return new nijs.NixFunction({
        argSpec: [
            "buildNodePackage",
            "fetchurl",
            "fetchgit",
            "self"
        ],
        body: new nijs.NixLet({
            value: {
                registry: this.registryExpr
            },
            body: new nijs.NixExpression("registry")
        })
    });
};

exports.Registry = Registry;
