var path = require('path');
var child_process = require('child_process');
var slasp = require('slasp');
var nijs = require('nijs');
var findit = require('findit');
var fs = require('fs.extra');
var Source = require('./Source.js').Source;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

var fetchgit = require('./fetchgit.js');

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

    /* Compose a metadata object out of the git repository */
    var tmpDir;
    var repositoryDir;

    var filesToDelete = [];
    var dirsToDelete = [];

    slasp.sequence([
        function(callback) {
            fetchgit.fetchGitRepository(self.dependencyName, self.versionSpec, callback);
        },

        function(callback, repository) {
            tmpDir = repository.tmpDir;
            repositoryDir = repository.repositoryDir;
            self.rev = repository.rev;
            self.url = repository.url;

            fs.readFile(path.join(repositoryDir, "package.json"), callback);
        },

        function(callback, packageJSON) {
            self.config = JSON.parse(packageJSON);

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
