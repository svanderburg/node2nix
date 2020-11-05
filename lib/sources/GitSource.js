var url = require('url');
var path = require('path');
var child_process = require('child_process');
var temp = require('temp');
var slasp = require('slasp');
var nijs = require('nijs');
var findit = require('findit');
var fs = require('fs.extra');
var Source = require('./Source.js').Source;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/**
 * Constructs a new GitSource instance.
 *
 * @class GitSource
 * @extends Source
 * @classdesc Represents a dependency source that is obtained by cloning a Git repository
 *
 * @constructor
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} dependencyName Name of the dependency
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 */
function GitSource(baseDir, dependencyName, versionSpec) {
    Source.call(this, baseDir, dependencyName, versionSpec);
    this.rev = "";
    this.hash = "";
    this.identifier = dependencyName + "-" + versionSpec;
    this.baseDir = path.join(baseDir, dependencyName);
}

/* GitSource inherits from Source */
inherit(Source, GitSource);

GitSource.composeGitURL = function(baseURL, parsedUrl) {
    var hashComponent;

    if(parsedUrl.hash === null) {
        hashComponent = "";
    } else {
        hashComponent = parsedUrl.hash;
    }

    return baseURL + "/" + parsedUrl.host + parsedUrl.path + hashComponent;
};

/**
 * @see Source#fetch
 */
GitSource.prototype.fetch = function(callback) {
    var self = this;

    /* Parse the URL specifier, extract useful bits out of it and rewrite it into a usable git URL */
    var parsedUrl = url.parse(self.versionSpec);

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

    delete parsedUrl.hash;

    /* Compose a Git URL out of the parsed object */
    self.url = parsedUrl.format();

    /* Compose a metadata object out of the git repository */
    var tmpDir;
    var repositoryDir;

    var filesToDelete = [];
    var dirsToDelete = [];

    slasp.sequence([
        function(callback) {
            /* Create a temp folder */
            temp.mkdir("node2nix-git-checkout-" + self.dependencyName.replace("/", "_slash_"), callback);
        },

        function(callback, dirPath) {
            tmpDir = dirPath;

            process.stderr.write("Cloning git repository: "+self.url+"\n");

            /* Do a git clone */
            var gitClone = child_process.spawn("git", [ "clone", self.url ], {
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
            /* When no commitIsh has been provide, parse the revision of HEAD */
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
                self.rev += data;
            });
            gitRevParse.stderr.on("data", function(data) {
                process.stderr.write(data);
            });
            gitRevParse.on("close", function(code) {
                if(code != 0)
                    self.rev = ""; // If git rev-parse fails, we consider the commitIsh a branch/tag.

                callback(null);
            });
        },

        function(callback) {
            if(commitIsh !== null && self.rev == "") {
                /* If we were still unable to parse a revision, we try to parse the revision of the origin's branch */
                process.stderr.write("Parsing the revision of commitish: origin/"+commitIsh+"\n");

                /* Resolve the hash of the branch/tag */
                var gitRevParse = child_process.spawn("git", [ "rev-parse", "origin/" + commitIsh ], {
                    cwd: repositoryDir
                });

                gitRevParse.stdout.on("data", function(data) {
                    self.rev += data;
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
            if(self.rev == "") {
                callback(null);
            } else {
                /* When we have resolved a revision, do a checkout of it */
                self.rev = self.rev.substr(0, self.rev.length - 1);

                process.stderr.write("Checking out revision: "+self.rev+"\n");

                /* Check out the corresponding revision */
                var gitCheckout = child_process.spawn("git", [ "checkout", self.rev ], {
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

        function(callback) {
            /* Read and parse package.json file inside the git checkout */
            self.config = JSON.parse(fs.readFileSync(path.join(repositoryDir, "package.json")));
            var lockFile = path.resolve(repositoryDir, "package-lock.json")
            if (fs.existsSync(lockFile)) {
                self.lockFile = JSON.parse(fs.readFileSync(lockFile));
            }
            callback(null)
        },

        function(callback) {
            /* Search for .git directories and files to prune out of the checkout */
            var finder = findit(repositoryDir);

            finder.on("directory", function(dir, stat) {
                var base = path.basename(dir);
                if(base == ".git") {
                    dirsToDelete.push(dir);
                }
            });
            finder.on("file", function(file, stat) {
                var base = path.basename(file);
                if(base == ".git") {
                    filesToDelete.push(file);
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
                self.hash += data;
            });
            nixHash.stderr.on("data", function(data) {
                process.stderr.write(data);
            });
            nixHash.on("close", function(code) {
                if(code == 0) {
                    callback(null);
                } else {
                    callback("nix-hash exited with status: "+code);
                }
            });
        }
    ], function(err) {
        if(tmpDir !== undefined) { // Remove the temp folder
            fs.rmrfSync(tmpDir);
        }

        callback(err);
    });
};

/**
 * @see Source#convertFromLockedDependency
 */
GitSource.prototype.convertFromLockedDependency = function(dependencyObj, callback) {
    this.fetch(callback); // A locked git dependency object does not provide any integrity metadata. We have to download and compute the hash ourselves.
};

/**
 * @see NixASTNode#toNixAST
 */
GitSource.prototype.toNixAST = function() {
    var ast = Source.prototype.toNixAST.call(this);

    ast.src = new nijs.NixFunInvocation({
        funExpr: new nijs.NixExpression("fetchgit"),
        paramExpr: {
            url: this.url,
            rev: this.rev,
            sha256: this.hash.substr(0, this.hash.length - 1)
        }
    });

    return ast;
};

exports.GitSource = GitSource;
