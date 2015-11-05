var slasp = require('slasp');
var nijs = require('nijs');
var npmconf = require('npmconf');
var RegClient = require('npm-registry-client');

/**
 * @member packagefetcher.npmregistry
 *
 * Fetches a Node.js package's metadata (the package.json and source code
 * reference) from the NPM registry.
 *
 * @param {String} dependencyName Name of the Node.js package to fetch
 * @param {String} versionSpec Version specifier of the Node.js package to fetch, which is a exact version number, or version range specifier, '*', 'latest', or 'unstable'
 * @param {String} registryURL URL of the NPM registry
 * @param {function(String, Object)} callback Callback function that gets invoked when the work is done.
 *     If some error ocurred, the error parameter is set to contain the error message.
 *     If the operation succeeds, it returns an object with the package configuration and a Nix object that fetches the source
 */
function fetchMetaDataFromNPMRegistry(dependencyName, versionSpec, registryURL, callback) {
    var self = this;
    
    if(versionSpec == "") // An empty versionSpec translates to *
        versionSpec = "*";
        
    slasp.sequence([
        function(callback) {
             /* Load NPM's configuration */
             npmconf.load(callback);
        },
        
        function(callback, config) {
             /* Fetch package.json from the registry using the dependency name and version specification */
             var client = new RegClient(config);
             var url = registryURL + "/" + dependencyName + "/" + versionSpec;
             
             client.get(url, {}, function(err, data, raw, res) {
                 if(err)
                     callback(err);
                 else
                     callback(null, data);
             });
        },
        
        function(callback, packageObj) {
            /* Return metadata object */
            
            callback(null, {
                packageObj: packageObj,
                src: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixExpression("fetchurl"),
                    paramExpr: {
                        url: packageObj.dist.tarball,
                        sha1: packageObj.dist.shasum
                    }
                })
            });
        }
    ], callback);
}

exports.fetchMetaDataFromNPMRegistry = fetchMetaDataFromNPMRegistry;
