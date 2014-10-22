var slasp = require('slasp');
var nijs = require('nijs');
var Registry = require('../registry.js').Registry;
var generate = require('./index.js');

/**
 * @member npm2nix.generator.collection
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
                registry.addDependencyClosure(baseDir, dependency, "latest", callback); // A string element means that we should take the latest corresponding version
                break;
            case "object":
                slasp.fromEach(function(callback) { // Objects have a version specification for each package
                    callback(null, dependency);
                }, function(dependencyName, callback) {
                    var versionSpec = dependency[dependencyName];
                    registry.addDependencyClosure(baseDir, dependencyName, versionSpec, callback);
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
 * @member npm2nix.generator.collection
 *
 * Generates a composition Nix expression allowing one to build a set of NPM
 * packages through Nix from the command-line.
 *
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 */
function collectionToCompositionExpr(outputNix, nodeEnvNix) {
    var expr = generate.generateCompositionExpr(outputNix, nodeEnvNix, new nijs.NixExpression("registry"));
    return nijs.jsToNix(expr);
}

exports.collectionToCompositionExpr = collectionToCompositionExpr;
