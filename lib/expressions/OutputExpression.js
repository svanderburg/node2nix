var nijs = require('nijs');
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;
var SourcesCache = require('../SourcesCache.js').SourcesCache;
var WorkspaceSource = require('../sources/WorkspaceSource').WorkspaceSource;

/**
 * Creates a new output expression instance.
 *
 * @class OutputExpression
 * @extends NixASTNode
 * @classdesc Represents an expression that contains one or more NPM packages
 *
 * @constructor
 */
function OutputExpression() {
    this.sourcesCache = new SourcesCache();
}

/* OutputExpression inherits from NixASTNode */
inherit(nijs.NixASTNode, OutputExpression);

/**
 * Resolves the sources of the dependencies and all transitive dependencies.
 *
 * @method
 * @param {function(String)} callback Callback that gets invoked when the work
 *     is done. In case of an error, the first parameter contains a string with
 *     an error message.
 */
OutputExpression.prototype.resolveDependencies = function(callback) {
    callback("resolveDependencies() is unimplemented. Please use a prototype that inherits from OutputExpression!");
};

/**
 * @see NixASTNode#toNixAST
 */
OutputExpression.prototype.toNixAST = function() {
    var argSpec = {
        nodeEnv: undefined,
        fetchurl: undefined,
        fetchgit: undefined,
        globalBuildInputs: []
    };

    // Add arguments for workspace dependencies
    for(var identifier in this.sourcesCache.sources) {
        var source = this.sourcesCache.sources[identifier];
        if(source instanceof WorkspaceSource && !source.symlink) {
            var varName = source.variableName();
            argSpec[varName] = source.fileExpression();
        }
    }

    return new nijs.NixFunction({
        argSpec: argSpec,
        body: new nijs.NixLet({
            value: {
                sources: this.sourcesCache
            }
        })
    });
};

exports.OutputExpression = OutputExpression;
