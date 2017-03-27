var slasp = require('slasp');
var nijs = require('nijs');

/**
 * Generates a Nix expression allowing a user to deploy a collection of NPM
 * packages.
 *
 * @param {PackageSet} packageSet Maintains a set of packages and their dependencies
 * @param {Object} dependencies An array of objects representing package specifications
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {Boolean} includePeerDependencies Indicates whether to include peer dependencies with the package
 * @param {Boolean} flatten Indicates whether to create a flat dependency structure in which dependencies are as high as possible in the graph
 * @param {function(String,Object)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns an object containing the abstract syntax of a Nix expression
 */
function generateCollectionExpr(packageSet, dependencies, baseDir, production, includePeerDependencies, flatten, callback) {
    var body = {};
    var i;
    
    slasp.sequence([
        function(callback) {
            slasp.from(function(callback) {
                i = 0;
                callback();
            }, function(callback) {
                callback(null, i < dependencies.length);
            }, function(callback) {
                i++;
                callback();
            }, function(callback) {
                /* Convert a string element into an object that takes the latest version, otherwise simply use the object */
                var dependencySpec = dependencies[i];
                var dependency;
                
                if(typeof dependencySpec == "string") {
                    dependency = {};
                    dependency[dependencySpec] = "latest";
                } else {
                    dependency = dependencySpec;
                }
                
                var resolvedDependencies = {};
                
                slasp.sequence([
                    function(callback) {
                        /* Resolve the dependencies of each package */
                        var metadata = {
                            parent: null,
                            baseDir: "./.",
                            boundDependencies: null // Dependencies cannot be bound on this level
                        };
                        
                        packageSet.resolveDependencies(resolvedDependencies, metadata, dependency, flatten, callback);
                    },
                   
                    function(callback) {
                       /* For each resolved dependency of a package, compose a function invocation that builds the package */
                       slasp.fromEach(function(callback) {
                           callback(null, resolvedDependencies);
                        }, function(dependencyName, callback) {
                            slasp.sequence([
                                function(callback) {
                                    /* Generate build function arguments */
                                    var metadata = resolvedDependencies[dependencyName];
                                    packageSet.generatePackageArgsExpr(metadata, production, includePeerDependencies, flatten, callback);
                                },
                                
                                function(callback, args) {
                                    /* Compose an attribute name for each package */
                                    var attrName;
                                    var versionSpec = dependency[dependencyName];
                                    
                                    if(versionSpec == "latest" || versionSpec == "*") {
                                        attrName = dependencyName; // For packages with version specifier 'latest' or '*' we don't append a version postfix
                                    } else {
                                        attrName = dependencyName + "-" + versionSpec;
                                    }
                                    
                                    /* Add function invocation that builds the package using the previously generated arguments expression */
                                    body[attrName] = new nijs.NixFunInvocation({
                                        funExpr: new nijs.NixAttrReference({
                                           attrSetExpr: new nijs.NixExpression("nodeEnv"),
                                           refExpr: new nijs.NixExpression("buildNodePackage")
                                        }),
                                        paramExpr: args
                                    });
                                    
                                    callback();
                                }
                            ], callback);
                        }, callback);
                    }
                ], callback);
            }, callback);
        },
        
        function(callback) {
            /* Wrap the set of function invocations into a composition function */
            var expr = packageSet.generatePackageSetFunctionExpr(body);
            callback(null, expr);
        }
    ], callback);
}

exports.generateCollectionExpr = generateCollectionExpr;
