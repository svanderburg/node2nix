var path = require('path');
var slasp = require('slasp');
var semver = require('semver');
var npmconf = require('npmconf');
var nijs = require('nijs');
var RegClient = require('npm-registry-client');
var Source = require('./Source.js').Source;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

var client;

/* Initialize client on first startup or return the existing one */

function initClient(callback) {
    if(client === undefined) {
        slasp.sequence([
            function(callback) {
                /* Load NPM's configuration */
                npmconf.load(callback);
            },

            function(callback, config) {
                client = new RegClient(config);
                callback(null, client);
            }
        ], callback)
    } else {
        callback(null, client);
    }
}

/**
 * Constructs a new NPMRegistrySource instance.
 *
 * @class NPMRegistrySource
 * @extends Source
 * @classdesc Represents a dependency source that is obtained from the metadata of a package in the NPM registry
 *
 * @constructor
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} dependencyName Name of the dependency
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 * @param {String} registryURL URL of the NPM registry
 * @param {Boolean} stripOptionalDependencies When enabled, the optional dependencies are stripped from the regular dependencies
 */
function NPMRegistrySource(baseDir, dependencyName, versionSpec, registryURL, stripOptionalDependencies) {
    Source.call(this, baseDir, dependencyName, versionSpec);
    this.registryURL = registryURL;
    this.baseDir = path.join(baseDir, dependencyName);
    this.stripOptionalDependencies = stripOptionalDependencies;
}

/* NPMRegistrySource inherits from Source */
inherit(Source, NPMRegistrySource);

/**
 * @see Source#fetch
 */
NPMRegistrySource.prototype.fetch = function(callback) {
    var self = this;

    if(self.versionSpec == "") // An empty versionSpec translates to *
        self.versionSpec = "*";

    slasp.sequence([
        initClient,

        function(callback, client) {
            /* Fetch package.json from the registry using the dependency name and version specification */
            var url = self.registryURL + "/" + self.dependencyName.replace("/", "%2F"); // Escape / to make scoped packages work

            client.get(url, {}, function(err, data, raw, res) {
                if(err) {
                    callback(err);
                } else if(data == undefined || data.versions === undefined) {
                    callback("Error fetching package: " + self.dependencyName + " from NPM registry!");
                } else {
                    callback(null, data);
                }
            });
        },

        function(callback, result) {
            /* Fetch the right version (and corresponding metadata) from the versions object */
            var versionIdentifiers = Object.keys(result.versions);
            var version;

            if(semver.validRange(self.versionSpec, true) === null) { // If the version specifier is not a valid semver range, we consider it a tag which we need to resolve to a version
                version = result['dist-tags'][self.versionSpec];
            } else {
                version = self.versionSpec;
            }

            // Take the right version's metadata from the versions object
            var resolvedVersion = semver.maxSatisfying(versionIdentifiers, version, true);

            if(resolvedVersion === null) {
                callback("Cannot resolve version: "+ self.dependencyName + "@" + version);
            } else {
                self.config = result.versions[resolvedVersion];
                self.identifier = self.config.name + "-" + self.config.version;

                if(self.stripOptionalDependencies && self.config.optionalDependencies !== undefined && self.config.dependencies !== undefined) {
                    /*
                     * The NPM registry has a weird oddity -- if a package has
                     * optionalDependencies, then these dependencies are added
                     * to the regular dependencies as well. We must deduct them
                     * so that we only work with the mandatory dependencies.
                     * Otherwise, certain builds may fail, because optional
                     * dependencies can be broken.
                     *
                     * I'm actually quite curious to learn about the rationale
                     * of this from the NPM developers.
                     */

                    for(var dependencyName in self.config.optionalDependencies) {
                        delete self.config.dependencies[dependencyName];
                    }
                }

                // Determine the output hash. If the package provides an integrity string, use it to compose a hash. Otherwise fall back to sha1

                if(self.config.dist.integrity !== undefined) {
                    self.convertIntegrityStringToNixHash(self.config.dist.integrity, callback);
                } else {
                    self.hashType = "sha1";
                    self.sha1 = self.config.dist.shasum; // SHA1 hashes are in hexadecimal notation which we can just adopt verbatim
                    callback();
                }
            }
        }
    ], callback);
};

/**
 * @see Source#convertFromLockedDependency
 */
NPMRegistrySource.prototype.convertFromLockedDependency = function(dependencyObj, callback) {
    this.config = {
        name: this.dependencyName,
        version: dependencyObj.version,
        dist: {
          tarball: dependencyObj.resolved
        }
    };
    this.identifier = this.dependencyName + "-" + dependencyObj.version;
    this.convertIntegrityStringToNixHash(dependencyObj.integrity, callback);
};

/**
 * @see NixASTNode#toNixAST
 */
NPMRegistrySource.prototype.toNixAST = function() {
    var ast = Source.prototype.toNixAST.call(this);

    var paramExpr = {
        url: this.config.dist.tarball
    };

    switch(this.hashType) {
        case "sha1":
            paramExpr.sha1 = this.sha1;
            break;
        case "sha512":
            paramExpr.sha512 = this.sha512;
            break;
    }

    ast.src = new nijs.NixFunInvocation({
        funExpr: new nijs.NixExpression("fetchurl"),
        paramExpr: paramExpr
    });

    return ast;
};

exports.NPMRegistrySource = NPMRegistrySource;
