var url = require('url');
var path = require('path');
var crypto = require('crypto');
var http = require('http');
var https = require('https');
var zlib = require('zlib');
var tar = require('tar');
var nijs = require('nijs');

/**
 * @member packagefetcher.http
 *
 * Fetches a Node.js package's metadata (the package.json and source code
 * reference) from an HTTP URL.
 *
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} dependencyName Name of the Node.js package to fetch
 * @param {String} versionSpec Version specifier of the Node.js package to fetch, which is an HTTP/HTTPS URL in this particular case
 * @param {function(String, Object)} callback Callback function that gets invoked when the work is done.
 *     If some error ocurred, the error parameter is set to contain the error message.
 *     If the operation succeeds, it returns an object with the package configuration and a Nix object that fetches the source
 */
function fetchMetaDataFromHTTP(baseDir, dependencyName, versionSpec, callback) {
    /* Determine which client to use depending on the parsed protocol */
    var parsedUrl = url.parse(versionSpec);
    var client;
    
    switch(parsedUrl.protocol) {
        case "http:":
            client = http;
            break;
        case "https:":
            client = https;
            break;
        default:
            return callback("Unsupported protocol: "+parsedUrl.protocol);
    }
    
    /* Request the package from the given URL */
    
    var request = client.get(parsedUrl.href, function(res) {
        if(res.statusCode >= 300 && res.statusCode <= 308) { // If a redirect has been encountered => do the same operation with the target URL
            if(!res.headers.location) {
                callback("Bad HTTP response while GETting "+parsedUrl.href+" Redirect with no Location header");
            } else {
                fetchMetaDataFromHTTP(baseDir, dependencyName, res.headers.location, callback);
            }
        } else { // Otherwise extract the package.json and compute the corresponding hash
        
            process.stderr.write("fetching: "+parsedUrl.href+"\n");
            
            var packageObj;
            var hash;
            
            /* Callback that gets invoked when the tar parser finished or the response has been received */
            function finish() {
                callback(null, {
                    packageObj: packageObj,
                    identifier: dependencyName + "-" + versionSpec,
                    src: new nijs.NixFunInvocation({
                        funExpr: new nijs.NixExpression("fetchurl"),
                        paramExpr: {
                            name: packageObj.name + "-" + packageObj.version + ".tar.gz",
                            url: new nijs.NixURL(parsedUrl.href),
                            sha256: hash
                        }
                    }),
                    baseDir: path.join(baseDir, dependencyName)
                });
            }
            
            var gunzip = zlib.createGunzip();
            gunzip.on("error", function(err) {
                callback("Error while gunzipping: "+err);
            });
            
            var tarParser = new tar.Parse();
            tarParser.on("error", function(err) {
                callback("Error while untarring: "+err);
            });
            tarParser.on("entry", function(entry) {
                
                if(entry.path.match(/^[^/]*\/package\.json$/)) { // Search for a file named package.json in the tar file
                    var packageJSON = "";
                    
                    entry.on("data", function(chunk) {
                        packageJSON += chunk;
                    });
                    
                    entry.on("end", function() {
                        packageObj = JSON.parse(packageJSON);
                        
                        if(hash !== undefined) { // Only consider the work done if the hash has been computed as well
                            finish();
                        }
                    });
                }
            });
            
            var computeHash = crypto.createHash('sha256');
            
            /* Pipe gunzipped data to the tar parser */
            gunzip.pipe(tarParser);
        
            res.on("data", function(chunk) {
                /* Retrieve data from the HTTP connection and feed it to the gunzip and hash streams */
                gunzip.write(chunk);
                computeHash.update(chunk);
            });
            res.on("end", function() {
                hash = computeHash.digest('hex');
                
                if(packageObj !== undefined) { // Only consider the work done if the package configuration has been extracted as well
                    finish();
                }
            });
            res.on("error", function(err) {
                callback("Error with retrieving file from HTTP connection: "+err);
            });
        }
    });
    request.on("error", function(err) {
        callback("Error while GETting "+parsedUrl.href+": "+err);
    });
}

exports.fetchMetaDataFromHTTP = fetchMetaDataFromHTTP;
