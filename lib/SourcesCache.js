var nijs = require('nijs');
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/**
 * Construct a new source cache instace.
 *
 * @class SourcesCache
 * @extends NixASTNode
 * @classdesc A cache store that memorizes all packages to obtain from external sources.
 *
 * @constructor
 */
function SourcesCache() {
    this.sources = {};
}

/* SourcesCache inherits from NixASTNode */
inherit(nijs.NixASTNode, SourcesCache);

/**
 * Checks whether a given source exists and if not, adds it to the cache.
 *
 * @method
 * @param {Source} source Any source object
 */
SourcesCache.prototype.addSource = function(source) {
    if(this.sources[source.identifier] === undefined) {
        this.sources[source.identifier] = source;
    }
};

/**
 * @see NixASTNode#toNixAST
 */
SourcesCache.prototype.toNixAST = function() {
    var self = this;
    var ast = {};

    Object.keys(self.sources).sort().forEach(function(identifier) {
        var source = self.sources[identifier];
        ast[identifier] = source.toNixAST();
    });

    return ast;
};

exports.SourcesCache = SourcesCache;
