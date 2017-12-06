var slasp = require('slasp');
var nijs = require('nijs');
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;
var OutputExpression = require('./OutputExpression.js').OutputExpression;
var Package = require('../Package.js').Package;

/**
 * Creates a new collection expression instance.
 *
 * @class CollectionExpression
 * @extends OutputExpression
 * @classdesc Represents an expression that contains multiple end user NPM packages.
 *
 * @constructor
 * @param {DeploymentConfig} deploymentConfig An object capturing global deployment settings
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {Array<String|Object>} dependencies An array of dependency specifications
 */
function CollectionExpression(deploymentConfig, baseDir, dependencies) {
    OutputExpression.call(this);

    // Compose package objects for all dependencies
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

            this.packages[identifier] = new Package(deploymentConfig, undefined, null, dependencyName, versionSpec, baseDir, deploymentConfig.production, this.sourcesCache);
        }
    }
}

/* CollectionExpression inherits from OutputExpression */
inherit(OutputExpression, CollectionExpression);

/**
 * @see OutputExpression#resolveDependencies
 */
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
    var ast = OutputExpression.prototype.toNixAST.call(this);

    // Generate sub expression for all the packages in the collection
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

    // Attach sub expression to the function body
    ast.body.body = packagesExpr;

    return ast;
};

exports.CollectionExpression = CollectionExpression;
