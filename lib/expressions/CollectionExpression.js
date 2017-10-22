var slasp = require('slasp');
var nijs = require('nijs');
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;
var SourcesCache = require('../SourcesCache.js').SourcesCache;
var Package = require('../Package.js').Package;

function CollectionExpression(deploymentConfig, baseDir, dependencies) {
    this.sourcesCache = new SourcesCache();
    this.packages = {};

    for(var i = 0; i < dependencies.length; i++) {
        var dependencySpec = dependencies[i];
        var dependency;

        if(typeof dependencySpec == "string") {
            dependency = {};
            dependency[dependencySpec] = "latest";
        } else {
            dependency = dependencySpec;
        }

        for(dependencyName in dependency) {
            var versionSpec = dependency[dependencyName];

            var identifier;

            if(versionSpec == "*" || versionSpec == "latest") { // Refer to packages of versions * or latest by name
                identifier = dependencyName;
            } else {
                identifier = dependencyName + "-" + versionSpec;
            }

            this.packages[identifier] = new Package(deploymentConfig, null, dependencyName, versionSpec, baseDir, deploymentConfig.production, this.sourcesCache);
        }
    }
}

/* CollectionExpression inherits from NixASTNode */
inherit(nijs.NixASTNode, CollectionExpression);

CollectionExpression.prototype.resolveDependencies = function(callback) {
    var self = this;

    slasp.fromEach(function(callback) {
        callback(null, self.packages);
    }, function(identifier, callback) {
        var pkg = self.packages[identifier];

        slasp.sequence([
            function(callback) {
                pkg.source.fetch(callback);
            },

            function(callback) {
                pkg.resolveDependencies(callback);
            }
        ], callback);
    }, callback);
};

/**
 * @see NixASTNode#toNixAST
 */
CollectionExpression.prototype.toNixAST = function() {
    var packagesExpr = {};

    for(var identifier in this.packages) {
        var pkg = this.packages[identifier];

        packagesExpr[identifier] = new nijs.NixFunInvocation({
            funExpr: new nijs.NixAttrReference({
               attrSetExpr: new nijs.NixExpression("nodeEnv"),
               refExpr: new nijs.NixExpression("buildNodePackage")
            }),
            paramExpr: pkg
        });
    }

    return new nijs.NixFunction({
        argSpec: {
            nodeEnv: undefined,
            fetchurl: undefined,
            fetchgit: undefined,
            globalBuildInputs: []
        },
        body: new nijs.NixLet({
            value: {
                sources: this.sourcesCache
            },
            body: packagesExpr
        })
    });
};

exports.CollectionExpression = CollectionExpression;
