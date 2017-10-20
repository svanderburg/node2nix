var slasp = require('slasp');
var nijs = require('nijs');
var Package = require('../Package.js').Package;
var SourcesCache = require('../SourcesCache.js').SourcesCache;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

function PackageExpression(deploymentConfig, baseDir, name, versionSpec) {
    this.sourcesCache = new SourcesCache();
    this.package = new Package(deploymentConfig, null, name, "./.", baseDir, deploymentConfig.production, this.sourcesCache);
}

/* PackageExpression inherits from NixASTNode */
inherit(nijs.NixASTNode, PackageExpression);

PackageExpression.prototype.resolveDependencies = function(callback) {
    var self = this;

    slasp.sequence([
        function(callback) {
            self.package.source.fetch(callback);
        },
        function(callback) {
            self.package.resolveDependencies(callback);
        }
    ], callback);
};

/**
 * @see NixASTNode#toNixAST
 */
PackageExpression.prototype.toNixAST = function() {
    return new nijs.NixFunction({
        argSpec: {
            nodeEnv: undefined,
            fetchurl: undefined,
            fetchgit: undefined,
            globalBuildInputs: []
        },
        body: new nijs.NixLet({
            value: {
                sources: this.sourcesCache,
                args: this.package
            },
            body: {
                tarball: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixAttrReference({
                        attrSetExpr: new nijs.NixExpression("nodeEnv"),
                        refExpr: new nijs.NixExpression("buildNodeSourceDist")
                    }),
                    paramExpr: new nijs.NixExpression("args")
                }),

                package: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixAttrReference({
                        attrSetExpr: new nijs.NixExpression("nodeEnv"),
                        refExpr: new nijs.NixExpression("buildNodePackage")
                    }),
                    paramExpr: new nijs.NixExpression("args")
                }),

                shell: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixAttrReference({
                        attrSetExpr: new nijs.NixExpression("nodeEnv"),
                        refExpr: new nijs.NixExpression("buildNodeShell")
                    }),
                    paramExpr: new nijs.NixExpression("args")
                })
            }
        })
    });
};

exports.PackageExpression = PackageExpression;
