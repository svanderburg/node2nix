var slasp = require('slasp');
var nijs = require('nijs');
var OutputExpression = require('./OutputExpression.js').OutputExpression;
var Package = require('../Package.js').Package;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/**
 * Creates a new package expression instance.
 *
 * @class PackageExpression
 * @extends OutputExpression
 * @classdesc Represents an expression that contains several jobs for a single package
 *
 * @constructor
 * @param {DeploymentConfig} deploymentConfig An object capturing global deployment settings
 * @param {Object} lock Contents of a package lock file (or undefined if no lock exists)
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} name Name of a Node.js package
 * @param {String} versionSpec Version specifier of a Node.js package, such as
 *     an exact version number, version range, URL, or GitHub identifier
 */
function PackageExpression(deploymentConfig, lock, baseDir, name, versionSpec) {
    OutputExpression.call(this);
    this.package = new Package(deploymentConfig, lock, null, name, "./.", baseDir, deploymentConfig.production, this.sourcesCache);
}

/* PackageExpression inherits from OutputExpression */
inherit(OutputExpression, PackageExpression);

/**
 * @see OutputExpression#resolveDependencies
 */
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
    var ast = OutputExpression.prototype.toNixAST.call(this);

    ast.body.value.args = this.package;
    ast.body.body = {
        args: new nijs.NixExpression("args"),
        sources: new nijs.NixExpression("sources"),
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

        shell: new nijs.NixAttrReference({
            attrSetExpr: new nijs.NixFunInvocation({
                funExpr: new nijs.NixAttrReference({
                    attrSetExpr: new nijs.NixExpression("nodeEnv"),
                    refExpr: new nijs.NixExpression("buildNodeShell")
                }),
                paramExpr: new nijs.NixExpression("args")
            }),
            paramExpr: new nijs.NixExpression("shell")
        }),

        nodeDependencies: new nijs.NixAttrReference({
            attrSetExpr: new nijs.NixFunInvocation({
                funExpr: new nijs.NixAttrReference({
                    attrSetExpr: new nijs.NixExpression("nodeEnv"),
                    refExpr: new nijs.NixExpression("buildNodeShell")
                }),
                paramExpr: new nijs.NixExpression("args")
            }),
            paramExpr: new nijs.NixExpression("nodeDependencies")
        })
    };

    return ast;
};

exports.PackageExpression = PackageExpression;
