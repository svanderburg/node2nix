var fs = require('fs');
var path = require('path');
var slasp = require('slasp');
var nijs = require('nijs');
var Source = require('./Source.js').Source;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/**
 * Constructs a new LocalSource instance.
 *
 * @class LocalSource
 * @extends Source
 * @classdesc Represents a dependency source that is obtained from a directory on the local filesystem
 *
 * @constructor
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 */
function LocalSource(baseDir, outputDir, versionSpec) {
    Source.call(this, baseDir, versionSpec);
    this.outputDir = outputDir;
}

/* LocalSource inherits from Source */
inherit(Source, LocalSource);

LocalSource.prototype.composeSourcePath = function(resolvedPath) {
    var first = this.versionSpec.substr(0, 1);

    if(first === '~' || first === '/') { // Path is absolute
        return this.versionSpec;
    } else {
        // Compose path relative to the output directory
        var srcPath = path.relative(this.outputDir, resolvedPath);

        if(srcPath.substr(0, 1) !== ".") {
            srcPath = "./"+srcPath; // If a path starts with a . prefix it, so that it is a valid path in the Nix language
        }

        return srcPath;
    }
};

/**
 * @see Source#fetch
 */
LocalSource.prototype.fetch = function(callback) {
    var self = this;

    process.stderr.write("fetching local directory: " + self.versionSpec + " from " + self.baseDir +"\n");

    var resolvedPath = path.resolve(self.baseDir, self.versionSpec);
    self.srcPath = self.composeSourcePath(resolvedPath);

    slasp.sequence([
        function(callback) {
            fs.readFile(path.join(resolvedPath, "package.json"), callback);
        },

        function(callback, packageJSON) {
            self.config = JSON.parse(packageJSON);
            self.identifier = self.config.name + "-" + self.versionSpec;
            self.baseDir = resolvedPath;
            callback();
        }
    ], callback);
};

/**
 * @see NixASTNode#toNixAST
 */
LocalSource.prototype.toNixAST = function() {
    var ast = Source.prototype.toNixAST.call(this);

    if(this.srcPath === "./") {
        ast["src"] = new nijs.NixFile({ value: "./." }); // ./ is not valid in the Nix expression language
    } else {
        ast["src"] = new nijs.NixFile({ value: this.srcPath });
    }

    return ast;
};

exports.LocalSource = LocalSource;
