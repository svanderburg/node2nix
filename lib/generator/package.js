var slasp = require('slasp');
var nijs = require('nijs');

/**
 * Generates a Nix expression providing a standard jobset for one individual
 * package allowing a user to generate a tarball, build a package or start a
 * shell session.
 *
 * @param {PackageSet} packageSet Maintains a set of packages and their dependencies
 * @param {Object} packageObj A package.json configuration file of a package
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {Boolean} includePeerDependencies Indicates whether to include peer dependencies with the package
 * @param {Boolean} flatten Indicates whether to create a flat dependency structure in which dependencies are as high as possible in the graph 
 * @param {function(String,Object)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns an object containing the abstract syntax of a Nix expression
 */
function generatePackageExpr(packageSet, packageObj, baseDir, production, includePeerDependencies, flatten, callback) {
    /* Construct metadata object for the package that we want to deploy */
    var metadata = {
        packageObj: packageObj,
        parent: null,
        src: new nijs.NixFile({ value: "./." }),
        baseDir: baseDir
    };
    
    /* Construct a Nix expression providing jobsets to deploy it */
    slasp.sequence([
        function(callback) {
            packageSet.generatePackageArgsExpr(metadata, production, includePeerDependencies, flatten, callback);
        },
        
        function(callback, args) {
            var expr = packageSet.generatePackageSetFunctionExpr({
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
            }, args);
            
            callback(null, expr);
        }
    ], callback);
}

exports.generatePackageExpr = generatePackageExpr;
