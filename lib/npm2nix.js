var fs = require('fs');
var path = require('path');
var slasp = require('slasp');
var nijs = require('nijs');
var Registry = require('./registry.js').Registry;

/**
 * @member npm2nix
 *
 * Generates a registry Nix expression from a package.json file.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {Object} packageObj Configuration of a Node.js package
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {Boolean} linkDependencies Indicates whether to symlink the dependencies instead of copying them
 * @param {String} registryURL URL of the NPM registry
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the package and all its dependencies
 */
function packageObjectToRegistryExpr(baseDir, packageObj, production, linkDependencies, registryURL, callback) {
    var src = new nijs.NixFile({ value: "./." });
    var registry = new Registry(registryURL, linkDependencies);
    
    registry.addPackage(baseDir, packageObj, src, production, function(err) {
        if(err) {
            callback("Cannot generate registry expression: "+err);
        } else {
            var composition = registry.toNixExpr();
            var registryStr = nijs.jsToNix(composition);
            callback(null, registryStr);
        }
    });
}

exports.packageObjectToRegistryExpr = packageObjectToRegistryExpr;

/**
 * @member npm2nix
 *
 * Generates a registry Nix expression from a collection of NPM dependendency specifications.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {Object} collection An array of strings or objects
 * @param {Boolean} linkDependencies Indicates whether to symlink the dependencies instead of copying them
 * @param {String} registryURL URL of the NPM registry
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the packages and all its dependencies
 */
function collectionToRegistryExpr(baseDir, collection, linkDependencies, registryURL, callback) {
    var registry = new Registry(registryURL, linkDependencies);
    var i;

    slasp.from(function(callback) {
        i = 0;
        callback(null);
    }, function(callback) {
        callback(null, i < collection.length);
    }, function(callback) {
        i++;
        callback(null);
    }, function(callback) {
        var dependency = collection[i];
    
        switch(typeof dependency) {
            case "string":
                registry.addDependencyClosure(dependency, "latest", callback); // A string element means that we should take the latest corresponding version
                break;
            case "object":
                slasp.fromEach(function(callback) { // Objects have a version specification for each package
                    callback(null, dependency);
                }, function(dependencyName, callback) {
                    var versionSpec = dependency[dependencyName];
                    registry.addDependencyClosure(dependencyName, versionSpec, callback);
                }, callback);
                break;
            default:
                callback("Unknown object type encountered in the array");
        }
    }, function(err) {
        if(err) {
            callback("Cannot generate registry expression: "+err);
        } else {
            var composition = registry.toNixExpr();
            var registryStr = nijs.jsToNix(composition);
            callback(null, registryStr);
        }
    });
}

exports.collectionToRegistryExpr = collectionToRegistryExpr;

function generateCompositionExpr(outputNix, nodeEnvNix, body) {
    return new nijs.NixFunction({
        argSpec: {
            system: new nijs.NixAttrReference({
                attrSetExpr: new nijs.NixExpression("builtins"),
                refExpr: new nijs.NixExpression("currentSystem")
            }),
            pkgs: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixExpression("<nixpkgs>")),
                paramExpr: {
                    system: new nijs.NixInherit()
                }
            }),
            overrides: {}
        },
        body: new nijs.NixLet({
            value: {
                nodeEnv: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixImport(new nijs.NixFile({ value: "./"+path.basename(nodeEnvNix) })),
                    paramExpr: {
                        stdenv: new nijs.NixInherit("pkgs"),
                        fetchurl: new nijs.NixInherit("pkgs"),
                        nodejs: new nijs.NixInherit("pkgs"),
                        python: new nijs.NixInherit("pkgs"),
                        utillinux: new nijs.NixInherit("pkgs"),
                        runCommand: new nijs.NixInherit("pkgs")
                    }
                }),
                registry: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixImport(new nijs.NixFile({ value: "./"+path.basename(outputNix) })),
                    paramExpr: {
                        buildNodePackage: new nijs.NixInherit("nodeEnv"),
                        fetchurl: new nijs.NixInherit("pkgs"),
                        fetchgit: new nijs.NixInherit("pkgs"),
                        self: new nijs.NixExpression("registry // overrides")
                    }
                })
            },
            body: body
        })
    });
}

/**
 * @member npm2nix
 *
 * Generates a composition Nix expression allowing one to build a NPM package
 * through Nix from the command-line.
 *
 * @param {Object} packageObj Configuration of a Node.js package
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 */
function packageObjectToCompositionExpr(packageObj, outputNix, nodeEnvNix) {
    var expr = generateCompositionExpr(outputNix, nodeEnvNix, {
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
    
    return nijs.jsToNix(expr);
}

exports.packageObjectToCompositionExpr = packageObjectToCompositionExpr;

/**
 * @member npm2nix
 *
 * Generates a composition Nix expression allowing one to build a set of NPM
 * packages through Nix from the command-line.
 *
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 */
function collectionToCompositionExpr(outputNix, nodeEnvNix) {
    var expr = generateCompositionExpr(outputNix, nodeEnvNix, new nijs.NixExpression("registry"));
    return nijs.jsToNix(expr);
}

exports.collectionToCompositionExpr = collectionToCompositionExpr;

/**
 * @member npm2nix
 *
 * Writes a copy of node-env.nix to a specified path.
 *
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 * @param {function(String)} callback Callback function that gets invoked if the operation is done.
 *     If an error has occured, the error parameter is set to the error message.
 */
function copyNodeEnvExpr(nodeEnvNix, callback) {
    /* Compose a read stream that reads the build expression */
    var rs = fs.createReadStream(path.join(path.dirname(module.filename), "..", "nix", "node-env.nix"));
    rs.on("error", function(err) {
        callback(err);
    });
    
    /* Compose a write stream that writes the build expression */
    var ws = fs.createWriteStream(nodeEnvNix);
    ws.on("error", function(err) {
        callback(err);
    });
    ws.on("close", function() {
        callback(null);
    });
    
    /* Pipe the data to actually copy stuff */
    rs.pipe(ws);
}

exports.copyNodeEnvExpr = copyNodeEnvExpr;

/**
 * @member npm2nix
 *
 * Generates a Nix expression from a JSON file representing a Node.js package
 * configuration or an array of NPM dependencies.
 *
 * @param {String} inputJSON Path to a package.json or arbitrary JSON file
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {String} compositionNix Path to which the generated composition expression is written
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {Boolean} linkDependencies Indicates whether to symlink the dependencies instead of copying them
 * @param {String} registryURL URL of the NPM registry
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the packages and all its dependencies
 */
function npmToNix(inputJSON, outputNix, compositionNix, nodeEnvNix, production, linkDependencies, registryURL, callback) {
    var obj = JSON.parse(fs.readFileSync(inputJSON));
    
    slasp.sequence([
        /* Generate a Nix expression */
        function(callback) {
            if(typeof obj == "object" && obj !== null) {
                var baseDir = path.dirname(inputJSON);
                
                if(Array.isArray(obj))
                    collectionToRegistryExpr(baseDir, obj, linkDependencies, registryURL, callback);
                else
                    packageObjectToRegistryExpr(baseDir, obj, production, linkDependencies, registryURL, callback);
            } else {
                callback("The provided JSON file must be an object or an array");
            }
        },
        
        /* Write the output Nix expression to the specified output file */
        function(callback, registryStr) {
            fs.writeFile(outputNix, registryStr, callback);
        },
        
        /* Copy the node-env.nix expression */
        function(callback) {
            copyNodeEnvExpr(nodeEnvNix, callback)
        },
        
        /* Generate and write a Nix composition expression to the specified output file */
        function(callback) {
            if(typeof obj == "object" && obj !== null) {
                var compositionStr;
                
                if(Array.isArray(obj))
                    compositionStr = collectionToCompositionExpr(outputNix, nodeEnvNix);
                else
                    compositionStr = packageObjectToCompositionExpr(obj, outputNix, nodeEnvNix);
                
                fs.writeFile(compositionNix, compositionStr, callback);
            } else {
                callback("The provided JSON file must consist of an object or an array");
            }
        }
    ], callback);
}

exports.npmToNix = npmToNix;
