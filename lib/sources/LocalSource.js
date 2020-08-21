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
 * @param {String} dependencyName Name of the dependency
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 */
function LocalSource(baseDir, dependencyName, outputDir, versionSpec) {
    Source.call(this, baseDir, dependencyName, versionSpec);
    this.outputDir = outputDir;
}

/* LocalSource inherits from Source */
inherit(Source, LocalSource);

LocalSource.prototype.composeSourcePath = function(resolvedPath) {
    var srcPath;

    // Strip of file: prefix if necessary
    if(resolvedPath.substr(0, 5) === "file:") {
        srcPath = resolvedPath.substr(5);
    } else {
        srcPath = resolvedPath;
    }

    var first = this.versionSpec.substr(0, 1);

    if(first === '~' || first === '/') { // Path is absolute
        return this.versionSpec;
    } else {
        // Compose path relative to the output directory
        var absoluteOutputDir = path.resolve(this.outputDir);
        var absoluteSrcPath = path.resolve(absoluteOutputDir, srcPath);
        srcPath = path.relative(absoluteOutputDir, absoluteSrcPath);

        if(srcPath.substr(0, 1) !== ".") {
            srcPath = "./"+srcPath; // If a path does not start with a . prefix it, so that it is a valid path in the Nix language
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
 * @see Source#convertFromLockedDependency
 */
LocalSource.prototype.convertFromLockedDependency = function(dependencyObj, callback) {
    this.srcPath = this.composeSourcePath(dependencyObj.version);
    this.config = {
        name: this.dependencyName,
        version: 1
    };
    this.identifier = this.dependencyName + "-" + this.versionSpec;
    callback();
};

/**
 * Create a NixFile AST node for the package source path.
 */
LocalSource.prototype.fileExpression = function() {
    if(this.srcPath === "./") {
        return new nijs.NixFile({ value: "./." }); // ./ is not valid in the Nix expression language
    } else if(this.srcPath === "..") {
        return new nijs.NixFile({ value: "./.." }); // .. is not valid in the Nix expression language
    } else {
        return new nijs.NixFile({ value: this.srcPath });
    }
};

/**
 * @see NixASTNode#toNixAST
 */
LocalSource.prototype.toNixAST = function() {
    var ast = Source.prototype.toNixAST.call(this);
    ast.src = this.fileExpression();
    return ast;
};

exports.LocalSource = LocalSource;
