var url = require('url');
var path = require('path');
var child_process = require('child_process');
var temp = require('temp');
var slasp = require('slasp');
var nijs = require('nijs');
var findit = require('findit');
var fs = require('fs.extra');

/**
 * @member packagefetcher.git
 *
 * Fetches a Node.js package's metadata (the package.json and source code
 * reference) from a Git repository.
 *
 * @param {String} dependencyName Name of the Node.js package to fetch
 * @param {String} versionSpec Version specifier of the Node.js package to fetch, which is a Git URL in this particular case
 * @param {function(String, Object)} callback Callback function that gets invoked when the work is done.
 *     If some error ocurred, the error parameter is set to contain the error message.
 *     If the operation succeeds, it returns an object with the package configuration and a Nix object that fetches the source
 */
function fetchMetaDataFromGit(dependencyName, versionSpec, callback) {
    
    /* Parse the URL specifier, extract useful bits out of it and rewrite it into a usable git URL */
    var parsedUrl = url.parse(versionSpec);
    
    switch(parsedUrl.protocol) {
        case "git+ssh:":
            parsedUrl.protocol = "ssh:";
            break;
        case "git+http:":
            parsedUrl.protocol = "http:";
            break;
        case "git+https:":
            parsedUrl.protocol = "https:";
            break;
        default:
            parsedUrl.protocol = "git:";
            break;
    }
    
    var commitIsh = parsedUrl.hash;
    if(commitIsh === null) // Use master as default commitish
        commitIsh = "master";
    else
        commitIsh = commitIsh.substr(1);
    
    delete parsedUrl.hash;
    
    var gitURL = parsedUrl.format();
    
    /* Compose a metadata object out of the git repository */
    var packageObj;
    var tmpDir;
    var repositoryDir;
    var rev = "";
    var hash = "";
    
    var filesToDelete = [];
    var dirsToDelete = [];
    
    slasp.sequence([
        function(callback) {
            /* Create a temp folder */
            temp.mkdir("npm2nix-git-checkout-" + dependencyName, callback);
        },
        
        function(callback, dirPath) {
            tmpDir = dirPath;
            
            process.stderr.write("Cloning git repository: "+gitURL+"\n");
            
            /* Do a git clone */
            var gitClone = child_process.spawn("git", [ "clone", gitURL ], {
                cwd: tmpDir,
                stdio: "inherit"
            });
            
            gitClone.on("close", function(code) {
                if(code == 0)
                    callback(null);
                else
                    callback("git clone exited with status: "+code);
            });
        },
        
        function(callback) {
            /* Search for the main folder in the clone */
            
            var finder = findit(tmpDir);
            finder.on("directory", function(dir, stat) {
                if(dir != tmpDir) {
                    repositoryDir = dir;
                    finder.stop();
                }
            });
            finder.on("stop", function() {
                callback(null);
            });
            finder.on("end", function() {
                callback("Cannot find a checkout directory in the temp folder");
            });
            finder.on("error", function(err) {
                callback(err);
            });
        },
        
        function(callback) {
            
            process.stderr.write("Parsing the revision of commitish: "+commitIsh+"\n");
            
            /* Check whether the given commitish corresponds to a hash */
            var gitRevParse = child_process.spawn("git", [ "rev-parse", commitIsh ], {
                cwd: repositoryDir
            });
            
            gitRevParse.stdout.on("data", function(data) {
                rev += data;
            });
            gitRevParse.stderr.on("data", function(data) {
                process.stderr.write(data);
            });
            gitRevParse.on("close", function(code) {
                if(code != 0)
                    rev = ""; // If git rev-parse fails, we consider the commitIsh a branch/tag.
                
                callback(null);
            });
        },
        
        function(callback) {
            if(rev == "") {
                process.stderr.write("Parsing the revision of commitish: origin/"+commitIsh+"\n");
            
                /* Resolve the hash of the branch/tag */
                var gitRevParse = child_process.spawn("git", [ "rev-parse", "origin/" + commitIsh ], {
                    cwd: repositoryDir
                });
                
                gitRevParse.stdout.on("data", function(data) {
                    rev += data;
                });
                gitRevParse.stderr.on("data", function(data) {
                    process.stderr.write(data);
                });
                gitRevParse.on("close", function(code) {
                    if(code == 0)
                        callback(null);
                    else
                        callback("Cannot find the corresponding revision of: "+commitIsh);
                });
            } else {
                callback(null);
            }
        },
        
        function(callback) {
            rev = rev.substr(0, rev.length - 1);
            
            process.stderr.write("Checking out revision: "+rev+"\n");
            
            /* Check out the corresponding revision */
            var gitCheckout = child_process.spawn("git", [ "checkout", rev ], {
                cwd: repositoryDir,
                stdio: "inherit"
            });
            
            gitCheckout.on("close", function(code) {
                if(code == 0)
                    callback(null);
                else
                    callback("git checkout exited with status: "+code);
            });
        },
    
        function(callback) {
            /* Read and parse package.json file inside the git checkout */
            fs.readFile(path.join(repositoryDir, "package.json"), callback);
        },
        
        function(callback, packageJSON) {
            packageObj = JSON.parse(packageJSON);
            
            /* Search for .git files to prune out of the checkout */
            var finder = findit(repositoryDir);
            
            finder.on("file", function(file, stat) {
                var base = path.basename(file);
                if(base.substr(0, ".git".length) == ".git") {
                    filesToDelete.push(file);
                }
            });
            finder.on("directory", function(dir, stat) {
                var base = path.basename(dir);
                if(base.substr(0, ".git".length) == ".git") {
                    dirsToDelete.push(dir);
                }
            });
            finder.on("end", function() {
                callback(null);
            });
            finder.on("error", function(err) {
                callback(err);
            });
        },
        
        function(callback) {
            /* Delete files that are prefixed with .git */
            var i;
            
            slasp.from(function(callback) {
                i = 0;
                callback(null);
            }, function(callback) {
                callback(null, i < filesToDelete.length);
            }, function(callback) {
                i++;
                callback(null);
            }, function(callback) {
                fs.unlink(filesToDelete[i], callback);
            }, callback);
        },
        
        function(callback) {
            /* Delete directories that are prefixed with .git */
            var i;
            
            slasp.from(function(callback) {
                i = 0;
                callback(null);
            }, function(callback) {
                callback(null, i < dirsToDelete.length);
            }, function(callback) {
                i++;
                callback(null);
            }, function(callback) {
                fs.rmrf(dirsToDelete[i], callback);
            }, callback);
        },
        
        function(callback) {
            /* Compute the SHA256 of the checkout */
            
            var nixHash = child_process.spawn("nix-hash", [ "--type", "sha256", repositoryDir ]);
            
            nixHash.stdout.on("data", function(data) {
                hash += data;
            });
            nixHash.stderr.on("data", function(data) {
                process.stderr.write(data);
            });
            nixHash.on("close", function(code) {
                if(code == 0)
                    callback(null);
                else
                    callback("nix-hash exited with status: "+code);
            });
        },
        
        function(callback) {
            /* Compose and return the package metadata object */
            callback(null, {
                packageObj: packageObj,
                src: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixExpression("fetchgit"),
                    paramExpr: {
                        url: gitURL,
                        rev: rev,
                        sha256: hash.substr(0, hash.length - 1)
                    }
                })
            });
        }
        
    ], function(err, metadata) {
        
        if(tmpDir !== undefined) // Remove the temp folder
            fs.rmrfSync(tmpDir);
        
        if(err) {
            callback(err);
        } else {
            callback(null, metadata);
        }
    });
}

exports.fetchMetaDataFromGit = fetchMetaDataFromGit;
