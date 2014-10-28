var nijs = require('nijs');
var Registry = require('../registry.js').Registry;
var generate = require('./index.js');

/**
 * @member npm2nix.generator.package
 *
 * Generates a registry Nix expression from a package.json file.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which the expression will be written
 * @param {Object} packageObj Configuration of a Node.js package
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {Boolean} linkDependencies Indicates whether to symlink the dependencies instead of copying them
 * @param {String} registryURL URL of the NPM registry
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the package and all its dependencies
 */
function packageObjectToRegistryExpr(baseDir, outputDir, packageObj, production, linkDependencies, registryURL, callback) {
    var src = new nijs.NixFile({ value: "./." });
    var registry = new Registry(registryURL, linkDependencies);
    
    registry.addPackage(baseDir, outputDir, packageObj, src, production, function(err) {
        if(err) {
            callback("Cannot generate registry expression: "+err);
        } else {
            var composition = registry.toNixExpr();
            var registryStr = nijs.jsToNix(composition, true);
            callback(null, registryStr);
        }
    });
}

exports.packageObjectToRegistryExpr = packageObjectToRegistryExpr;

/**
 * @member npm2nix.generator.package
 *
 * Generates a composition Nix expression allowing one to build a NPM package
 * through Nix from the command-line.
 *
 * @param {Object} packageObj Configuration of a Node.js package
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 */
function packageObjectToCompositionExpr(packageObj, outputNix, nodeEnvNix) {
    var expr = generate.generateCompositionExpr(outputNix, nodeEnvNix, {
        registry: new nijs.NixInherit(),
        
        tarball: new nijs.NixFunInvocation({
            funExpr: new nijs.NixAttrReference({
                attrSetExpr: new nijs.NixExpression("nodeEnv"),
                refExpr: new nijs.NixExpression("buildNodeSourceDist")
            }),
            paramExpr: {
                name: packageObj.name,
                version: packageObj.version,
                src: new nijs.NixFile({ value: "./." })
            }
        }),
        
        build: new nijs.NixFunInvocation({
            funExpr: new nijs.NixAttrReference({
                attrSetExpr: new nijs.NixExpression("registry"),
                refExpr: packageObj.name + "-" + packageObj.version
            }),
            paramExpr: {}
        })
    });
    
    return nijs.jsToNix(expr, true);
}

exports.packageObjectToCompositionExpr = packageObjectToCompositionExpr;
