var fs = require('fs');
var path = require('path');
var slasp = require('slasp');
var nijs = require('nijs');

function composeSourcePath(outputDir, versionSpec, resolvedPath) {
    var first = versionSpec.substr(0, 1);
    
    if(first === '~' || first === '/') { // Path is absolute
        return versionSpec;
    } else {
        // Compose path relative to the output directory
        var srcPath = path.relative(outputDir, resolvedPath);
        
        if(srcPath.substr(0, 1) !== ".") {
            srcPath = "./"+srcPath; // If a path starts with a . prefix it, so that it is a valid path in the Nix language
        }
        
        return srcPath;
    }
}

/**
 * @member packagefetcher.local
 *
 * Fetches a Node.js package's metadata (the package.json and source code
 * reference) from a local directory
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {String} versionSpec Version specifier of the Node.js package to fetch, which is a local path in this particular case
 * @param {function(String, Object)} callback Callback function that gets invoked when the work is done.
 *     If some error ocurred, the error parameter is set to contain the error message.
 *     If the operation succeeds, it returns an object with the package configuration and a Nix object that fetches the source
 */
function fetchMetaDataFromLocalDirectory(baseDir, outputDir, versionSpec, callback) {
    process.stderr.write("fetching local directory: "+versionSpec+" from "+baseDir+"\n");
    
    var resolvedPath = path.resolve(baseDir, versionSpec);
    var srcPath = composeSourcePath(outputDir, versionSpec, resolvedPath);
    
    slasp.sequence([
        function(callback) {
            fs.readFile(path.join(resolvedPath, "package.json"), callback);
        },
        
        function(callback, packageJSON) {
            var packageObj = JSON.parse(packageJSON);
            
            callback(null, {
                baseDir: resolvedPath,
                identifier: packageObj.name + "-" + versionSpec,
                packageObj: packageObj,
                src: new nijs.NixFile({ value: srcPath })
            });
        }
    ], callback);
}

exports.fetchMetaDataFromLocalDirectory = fetchMetaDataFromLocalDirectory;
