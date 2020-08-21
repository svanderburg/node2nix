var nijs = require('nijs');
var Source = require('./Source.js').Source;
var LocalSource = require('./LocalSource.js').LocalSource;
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/**
 * Constructs a new WorkspaceSource instance.
 *
 * @class WorkspaceSource
 * @extends LocalSource
 * @classdesc Represents a dependency source that is part of the same project
 *
 * @constructor
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} dependencyName Name of the dependency
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 */
function WorkspaceSource(baseDir, dependencyName, outputDir, versionSpec) {
    LocalSource.call(this, baseDir, dependencyName, outputDir, versionSpec);
    this.symlink = false;
}

/* WorkspaceSource inherits from LocalSource */
inherit(LocalSource, WorkspaceSource);

/**
 * @see Source#versionSatisfies
 */
WorkspaceSource.prototype.versionSatisfies = function() {
    return true; // Ignore version for packages part of the same project
};

/**
 * @see NixASTNode#toNixAST
 */
WorkspaceSource.prototype.toNixAST = function() {
    // Override LocalSource method, but do call super Source method
    var ast = Source.prototype.toNixAST.call(this);

    if(this.symlink) {
        // Use a symlink if the output directory contains the package
        ast.symlink = this.versionSpec;
    } else {
        // The package is bundled, but it may need to be built
        // Use a variable to allow the user to provide a custom derivation
        ast.src = new nijs.NixExpression(ast.name);
    }

    return ast;
};

exports.WorkspaceSource = WorkspaceSource;
