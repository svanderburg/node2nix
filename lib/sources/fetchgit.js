var child_process = require('child_process');
var findit = require('findit');
var slasp = require('slasp');
var temp = require('temp');
var url = require('url');

function fetchGitRepository(dependencyName, versionSpec, callback) {
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

    /* Compose the commitIsh out of the hash suffix, if applicable */
    var commitIsh;

    if(parsedUrl.hash !== null) {
        commitIsh = parsedUrl.hash.substr(1);
    } else {
        commitIsh = null;
    }

    /* Compose a Git URL out of the parsed object (without the hash suffix) */
    delete parsedUrl.hash;
    repoUrl = parsedUrl.format();

    var tmpDir;
    var repositoryDir;
    var rev = "";

    slasp.sequence([
        function(callback) {
            /* Create a temp folder */
            temp.mkdir("node2nix-git-checkout-" + dependencyName.replace("/", "_slash_"), callback);
        },

        function(callback, dirPath) {
            tmpDir = dirPath;

            process.stderr.write("Cloning git repository: "+repoUrl+"\n");

            /* Do a git clone */
            var gitClone = child_process.spawn("git", [ "clone", repoUrl ], {
                cwd: tmpDir,
                stdio: "inherit"
            });

            gitClone.on("close", function(code) {
                if(code == 0) {
                    callback(null);
                } else {
                    callback("git clone exited with status: "+code);
                }
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
            /* When no commitIsh has been provided, parse the revision of HEAD */
            var branch;

            if(commitIsh === null) {
                branch = "HEAD";
            } else {
                branch = commitIsh;
            }

            process.stderr.write("Parsing the revision of commitish: "+branch+"\n");

            /* Check whether the given commitish corresponds to a hash */
            var gitRevParse = child_process.spawn("git", [ "rev-parse", branch ], {
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
            if(commitIsh !== null && rev == "") {
                /* If we were still unable to parse a revision, we try to parse the revision of the origin's branch */
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
                    if(code == 0) {
                        callback(null);
                    } else {
                        callback("Cannot find the corresponding revision of: "+commitIsh);
                    }
                });
            } else {
                callback(null);
            }
        },

        function(callback) {
            if(rev == "") {
                callback(null);
            } else {
                /* When we have resolved a revision, do a checkout of it */
                rev = rev.substr(0, rev.length - 1);

                process.stderr.write("Checking out revision: "+rev+"\n");

                /* Check out the corresponding revision */
                var gitCheckout = child_process.spawn("git", [ "checkout", rev ], {
                    cwd: repositoryDir,
                    stdio: "inherit"
                });

                gitCheckout.on("close", function(code) {
                    if(code == 0) {
                        callback(null);
                    } else {
                        callback("git checkout exited with status: "+code);
                    }
                });
            }
        },

        function(callback) {
            /* Initialize all sub modules */
            process.stderr.write("Initializing git sub modules\n");

            var gitSubmoduleUpdate = child_process.spawn("git", [ "submodule", "update", "--init", "--recursive" ], {
                cwd: repositoryDir,
                stdio: "inherit"
            });

            gitSubmoduleUpdate.on("close", function(code) {
                if(code == 0) {
                    callback(null);
                } else {
                    callback("git submodule exited with status: "+code);
                }
            });
        },
    ], function(err) {
        if(err) {
            callback(err);
        } else {
            callback(null, {
                rev: rev,
                url: repoUrl,
                tmpDir: tmpDir,
                repositoryDir: repositoryDir
            });
        }
    });
}

exports.fetchGitRepository = fetchGitRepository;
