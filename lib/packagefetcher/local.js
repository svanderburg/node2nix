var fs = require('fs');
var path = require('path');
var slasp = require('slasp');
var nijs = require('nijs');

/**
 * Fetches a Node.js package's metadata (the package.json and source code
 * reference) from a local directory
 *
 * @param {String} versionSpec Version specifier of the Node.js package to fetch, which is a local path in this particular case
 * @param {function(String, Object)} callback Callback function that gets invoked when the work is done.
 *     If some error ocurred, the error parameter is set to contain the error message.
 *     If the operation succeeds, it returns an object with the package configuration and a Nix object that fetches the source
 */
function fetchMetaDataFromLocalDirectory(versionSpec, callback) {
    process.stderr.write("fetching local directory: "+versionSpec+"\n");
    
    slasp.sequence([
        function(callback) {
            fs.readFile(path.join(versionSpec, "package.json"), callback);
        },
        
        function(callback, packageJSON) {
            var packageObj = JSON.parse(packageJSON);
            callback(null, {
                packageObj: packageObj,
                src: new nijs.NixFile({ value: versionSpec })
            });
        }
    ], callback);
}

exports.fetchMetaDataFromLocalDirectory = fetchMetaDataFromLocalDirectory;
