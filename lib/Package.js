var path = require('path');
var slasp = require('slasp');
var semver = require('semver');
var nijs = require('nijs');
var Source = require('./sources/Source.js').Source;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/**
 * Creates a new package object.
 *
 * @class Package
 * @extends NixASTNode
 * @classdesc A representation of an NPM package that is obtained from an external source,
 * that may have dependencies on other packages, and may bundle packages in its
 * node_modules/ sub folder.
 *
 * @constructor
 * @param {DeploymentConfig} deploymentConfig An object capturing global deployment settings
 * @param {Object} lock Contents of a package lock file (or undefined if no lock exists)
 * @param {Package} parent Reference to the package that embeds the constructed
 *     package, or null if there is no parent
 * @param {String} name Name of a Node.js package
 * @param {String} versionSpec Version specifier of a Node.js package, such as
 *     an exact version number, version range, URL, or GitHub identifier
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {Boolean} production Indicates whether we deploy in production mode or
       development mode. In development mode, also the development dependencies
       will be included.
 * @param {SourcesCache} sourcesCache Cache that contains references to all sources that need to be obtained
 */
function Package(deploymentConfig, lock, parent, name, versionSpec, baseDir, production, sourcesCache) {
    this.deploymentConfig = deploymentConfig;
    this.lock = lock;
    this.parent = parent;
    this.production = production;
    this.sourcesCache = sourcesCache;
    this.source = Source.constructSource(deploymentConfig.registryURL, baseDir, deploymentConfig.outputDir, name, versionSpec, deploymentConfig.stripOptionalDependencies);
    this.requiredDependencies = {};
    this.providedDependencies = {};
}

/* Package inherits from NixASTNode */
inherit(nijs.NixASTNode, Package);

/**
 * Recursively checks the enclosing parent packages to see whether a dependency
 * exists that fits within the required version range.
 *
 * @method
 * @param {String} name Name of a Node.js package
 * @param {String} versionSpec Version specifier of a Node.js package, such as
 *     an exact version number, version range, URL, or GitHub identifier
 * @return {Package} The nearest parent package matching the version specifier
 *     or null if no such package exists
 */
Package.prototype.findMatchingProvidedDependencyByParent = function(name, versionSpec) {
    if(this.parent === null) { // If there is no parent, then we can also not provide a dependency
        return null;
    } else {
        var dependency = this.parent.providedDependencies[name];

        if(dependency === undefined) {
            return this.parent.findMatchingProvidedDependencyByParent(name, versionSpec); // If the parent does not provide the dependency, try the parent's parent
        } else if(dependency === null) {
             return null; // If we have encountered a bundled dependency with the same name, consider it a conflict (is not a perfect resolution, but does not result in an error)
        } else {
            if(semver.satisfies(dependency.source.config.version, versionSpec, true)) { // If we found a dependency with the same name, see if the version fits
                return dependency;
            } else {
                return null; // If there is a version mismatch, then a conflicting version has been encountered
            }
        }
    }
};

/**
 * Checks whether a dependency with a given name is already bundled with this
 * package.
 *
 * @method
 * @param {String} dependencyName Name of the dependency
 * @return {Boolean} true if the dependency is bundled, else false
 */
Package.prototype.isBundledDependency = function(dependencyName) {
    if(Array.isArray(this.source.config.bundledDependencies)) {
        for(var i = 0; i < this.source.config.bundledDependencies.length; i++) {
            if(dependencyName == this.source.config.bundledDependencies[i])
                return true;
        }
    }

    if(Array.isArray(this.source.config.bundleDependencies)) {
        for(var i = 0; i < this.source.config.bundleDependencies.length; i++) {
            if(dependencyName == this.source.config.bundleDependencies[i])
                return true;
        }
    }

    return false;
};

/**
 * Bundles a dependency (that is fetched from an external location) to the
 * package (or a parent package if flattening has been enabled). A bundled
 * package will appear in the node_modules/ sub folder of the package.
 *
 * @method
 * @param {String} dependencyName Name of the dependency
 * @param {Package} pkg Package to bundle in the node_modules/ sub folder
 */
Package.prototype.bundleDependency = function(dependencyName, pkg) {
    this.requiredDependencies[dependencyName] = pkg;

    if(this.deploymentConfig.flatten) { // In flatten mode, bundle dependency with the highest parent where it is not conflicting
        if(this.parent !== null && this.parent.providedDependencies[dependencyName] === undefined && this.parent.requiredDependencies[dependencyName] === undefined) {
            this.parent.bundleDependency(dependencyName, pkg);
        } else {
            pkg.parent = this;
            this.providedDependencies[dependencyName] = pkg;
        }
    } else {
        this.providedDependencies[dependencyName] = pkg; // Bundle the dependency with the package
    }
};

/**
 * Bundles a collection of dependencies with this package (or when flattening
 * mode has been enabled) any parent package that does not conflict and
 * automatically fetches its metadata by downloading it.
 *
 * @method
 * @param {Array<Package>} resolvedDependencies Memorizes the dependencies that have been resolved so that we can resolve their transitive dependencies later.
 * @param {Array<Package>} dependencies Dependencies to bundle with the package
 * @param {function(Object)} callback Callback that gets invoked then the work
 *     is done. The first parameter is set to an error object if the operation
 *     fails.
 */
Package.prototype.bundleDependencies = function(resolvedDependencies, dependencies, callback) {
    if(dependencies === undefined) {
        callback();
    } else {
        var self = this;

        slasp.fromEach(function(callback) {
            callback(null, dependencies);
        }, function(dependencyName, callback) {
            var versionSpec = dependencies[dependencyName];
            var parentDependency = self.findMatchingProvidedDependencyByParent(dependencyName, versionSpec);

            if(self.isBundledDependency(dependencyName)) {
                self.requiredDependencies[dependencyName] = null;
                callback();
            } else if(parentDependency === null) {
                var pkg = new Package(self.deploymentConfig, self.lock, self, dependencyName, versionSpec, self.source.baseDir, true /* Never include development dependencies of transitive dependencies */, self.sourcesCache);

                slasp.sequence([
                    function(callback) {
                        pkg.source.fetch(callback);
                    },

                    function(callback) {
                        self.sourcesCache.addSource(pkg.source);
                        self.bundleDependency(dependencyName, pkg);
                        resolvedDependencies[dependencyName] = pkg;
                        callback();
                    }
                ], callback);
            } else {
                self.requiredDependencies[dependencyName] = parentDependency; // If there is a parent package that provides the requested dependency -> use it
                callback();
            }

        }, callback);
    }
};

Package.prototype.resolveDependenciesAndSources = function(callback) {
    var self = this;
    var resolvedDependencies = {};

    slasp.sequence([
        function(callback) {
            self.bundleDependencies(resolvedDependencies, self.source.config.dependencies, callback);
        },

        function(callback) {
            /* Bundle the development dependencies, if applicable */
            if(self.production) {
                callback();
            } else {
                self.bundleDependencies(resolvedDependencies, self.source.config.devDependencies, callback);
            }
        },

        function(callback) {
            if(self.deploymentConfig.includePeerDependencies) {
                /* Bundle the peer dependencies, if applicable */
                self.bundleDependencies(resolvedDependencies, self.source.config.peerDependencies, callback);
            } else {
                callback();
            }
        },

        function(callback) {
            /* Bundle transitive dependencies */

            slasp.fromEach(function(callback) {
                callback(null, resolvedDependencies);
            }, function(dependencyName, callback) {
                var dependency = resolvedDependencies[dependencyName];
                dependency.resolveDependenciesAndSources(callback);
            }, callback);
        }
    ], callback);
};

Package.prototype.resolveDependenciesFromLockedDependencies = function(dependencyObj, callback) {
    var self = this;

    if(dependencyObj.dependencies === undefined) {
        callback();
    } else {
        slasp.fromEach(function(callback) {
            callback(null, dependencyObj.dependencies);
        }, function(dependencyName, callback) {
            var dependency = dependencyObj.dependencies[dependencyName];

            if(dependency.bundled) { // Bundled dependencies should not be included
                callback();
            } else if(self.deploymentConfig.stripOptionalDependencies && dependency.optional) { // When striping optional dependencies feature has been enabled, remove all optional dependencies
                callback();
            } else if(self.production && dependency.dev) { // Development dependencies should not be included in production mode
                callback();
            } else {
                var pkg = new Package(self.deploymentConfig, self.lock, self, dependencyName, dependency.version, self.source.baseDir, self.production, self.sourcesCache);
                self.providedDependencies[dependencyName] = pkg;

                slasp.sequence([
                    function(callback) {
                        pkg.source.convertFromLockedDependency(dependency, callback);
                    },

                    function(callback) {
                        self.sourcesCache.addSource(pkg.source);
                        pkg.resolveDependenciesFromLockedDependencies(dependency, callback);
                    }
                ], callback);
            }
        }, callback);
    }
};

/**
 * Resolves all dependencies and transitive dependencies of this package.
 *
 * @method
 * @param {function(Object)} callback Callback that gets invoked then the work
 *     is done. The first parameter is set to an error object if the operation
 *     fails.
 */
Package.prototype.resolveDependencies = function(callback) {
    if(this.lock === undefined) { // If no lock file is present, let the tool fetch all dependencies and metadata
        this.resolveDependenciesAndSources(callback);
    } else { // If we have a lock file, use that to generate Nix expressions
        this.resolveDependenciesFromLockedDependencies(this.lock, callback);
    }
};

/**
 * Composes an abstract syntax tree for the provided NPM dependencies by this
 * package.
 *
 * @method
 * @return {Array} An array representing a list of NPM package dependencies
 */
Package.prototype.generateDependencyAST = function() {
    var self = this;
    var dependencies = [];

    Object.keys(self.providedDependencies).sort().forEach(function(dependencyName) {
        var dependency = self.providedDependencies[dependencyName];

        // For each dependency, refer to the source attribute set that defines it
        var ref = new nijs.NixAttrReference({
            attrSetExpr: new nijs.NixExpression("sources"),
            refExpr: dependency.source.identifier
        });

        var transitiveDependencies = dependency.generateDependencyAST();
        var dependencyExpr;

        if(transitiveDependencies === undefined) {
            dependencyExpr = ref; // If a dependency has no dependencies of its own, we just refer to the attribute in the source set
        } else {
            // If a dependency has dependencies, we augment the reference with the set of dependencies that it needs
            dependencyExpr = new nijs.NixMergeAttrs({
                left: ref,
                right: {
                    dependencies: transitiveDependencies
                }
            });
        }

        dependencies.push(dependencyExpr);
    });

    if(dependencies.length == 0) {
        return undefined; // If no dependencies are required, simply compose no parameter. Though not mandatory, it improves readability of the generated expression
    } else {
        return dependencies;
    }
};

/**
 * @see NixASTNode#toNixAST
 */
Package.prototype.toNixAST = function() {
    var homepage;

    if(typeof this.source.config.homepage == "string" && this.source.config.homepage) {
        homepage = new nijs.NixURL(this.source.config.homepage);
    }

    var ast = this.source.toNixAST();
    ast.dependencies = this.generateDependencyAST();
    ast.buildInputs = new nijs.NixExpression("globalBuildInputs");
    ast.meta = {
        description: this.source.config.description,
        homepage: homepage,
        license: this.source.config.license
    };
    ast.production = this.production;
    ast.bypassCache = this.deploymentConfig.bypassCache;

    return ast;
};

exports.Package = Package;
