var fs = require('fs');
var path = require('path');
var slasp = require('slasp');
var nijs = require('nijs');
var Registry = require('./registry.js').Registry;

/**
 * Generates a registry Nix expression from a package.json file.
 *
 * @param {Object} packageObj Configuration of a Node.js package
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the package and all its dependencies
 */
function packageObjectToRegistryExpr(packageObj, production, callback) {
    var src = new nijs.NixFile({
        value: "./."
    });
    var registry = new Registry();
    
    registry.addPackage(packageObj, src, production, function(err) {
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
 * Generates a registry Nix expression from a collection of NPM dependendency specifications.
 *
 * @param {Object} collection An array of strings or objects
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the packages and all its dependencies
 */
function collectionToRegistryExpr(collection, callback) {
    var registry = new Registry();
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
                    registry.addDependencyClosure(dependencyName, versionSpec, production, callback);
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

/**
 * Generates a Nix expression from a JSON file representing a Node.js package
 * configuration or an array of NPM dependencies.
 *
 * @param {String} inputJSON Path to a package.json or arbitrary JSON file
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {Boolean} production Indicates whether to deploy the package in production mode
 * @param {function(String, String)} callback Callback function that gets invoked when the work is done.
 *     If an error occurs, the error parameter is set to contain the error
 *     If the operation succeeds, it returns a string containing the registry expression containing the packages and all its dependencies
 */
function npmToNix(inputJSON, outputNix, production, callback) {
    var obj = JSON.parse(fs.readFileSync(inputJSON));
    
    slasp.sequence([
        /* Generate a Nix expression */
        function(callback) {
            if(typeof obj == "object" && obj !== null) {
                if(Array.isArray(obj))
                    collectionToRegistryExpr(obj, callback);
                else
                    packageObjectToRegistryExpr(obj, production, callback);
            } else {
                callback("The provided JSON file must be an object or an array");
            }
        },
        
        /* Write the Nix expression to the specified output file */
        function(callback, registryStr) {
            fs.writeFile(outputNix, registryStr, callback);
        }
    ], callback);
}

exports.npmToNix = npmToNix;
