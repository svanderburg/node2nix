var url = require('url');
var semver = require('semver');
var nijs = require('nijs');
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;
var base64js = require('base64-js');

/**
 * Creates a new source instance. This function should never be used directly,
 * instead use: Source.constructSource to construct a source object.
 *
 * @class Source
 * @extends NixASTNode
 * @classdesc Represents a file that is obtained from an external source
 *
 * @constructor
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} dependencyName Name of the dependency
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 */
function Source(baseDir, dependencyName, versionSpec) {
    this.baseDir = baseDir;
    this.dependencyName = dependencyName;
    this.versionSpec = versionSpec;
}

/* Source inherits from NixASTNode */
inherit(nijs.NixASTNode, Source);

/**
 * Constructs a specific kind of source by inspecting the version specifier.
 *
 * @param {Registry[]} registries
 * @param {String} baseDir Directory in which the referrer's package.json configuration resides
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {String} dependencyName Name of the dependency
 * @param {String} versionSpec Version specifier of the Node.js package to fetch
 * @param {Boolean} stripOptionalDependencies When enabled, the optional
 *   dependencies are stripped from the regular dependencies in the NPM registry
 */
Source.constructSource = function(registries, baseDir, outputDir, dependencyName, versionSpec, stripOptionalDependencies) {
    // Load modules here, to prevent cycles in the include process
    var GitSource = require('./GitSource.js').GitSource;
    var HTTPSource = require('./HTTPSource.js').HTTPSource;
    var LocalSource = require('./LocalSource.js').LocalSource;
    var NPMRegistrySource = require('./NPMRegistrySource.js').NPMRegistrySource;

    var parsedUrl = url.parse(versionSpec);

    if(parsedUrl.protocol == "github:") { // If the version is a GitHub repository, compose the corresponding Git URL and do a Git checkout
        return new GitSource(baseDir, dependencyName, GitSource.composeGitURL("git+https://github.com", parsedUrl));
    } else if(parsedUrl.protocol == "gist:") { // If the version is a GitHub gist repository, compose the corresponding Git URL and do a Git checkout
        return new GitSource(baseDir, dependencyName, GitSource.composeGitURL("git+https://gist.github.com", parsedUrl));
    } else if(parsedUrl.protocol == "bitbucket:") { // If the version is a Bitbucket repository, compose the corresponding Git URL and do a Git checkout
        return new GitSource(baseDir, dependencyName, GitSource.composeGitURL("git+https://bitbucket.org", parsedUrl));
    } else if(parsedUrl.protocol == "gitlab:") { // If the version is a Gitlab repository, compose the corresponding Git URL and do a Git checkout
        return new GitSource(baseDir, dependencyName, GitSource.composeGitURL("git+https://gitlab.com", parsedUrl));
    } else if(typeof parsedUrl.protocol == "string" && parsedUrl.protocol.substr(0, 3) == "git") { // If the version is a Git URL do a Git checkout
        return new GitSource(baseDir, dependencyName, versionSpec);
    } else if(parsedUrl.protocol == "http:" || parsedUrl.protocol == "https:") { // If the version is an HTTP URL do a download
        return new HTTPSource(baseDir, dependencyName, versionSpec);
    } else if(versionSpec.match(/^[a-zA-Z0-9_\-]+\/[a-zA-Z0-9\.]+([#[a-zA-Z0-9_\-]|pull\/[0-9]+\/[a-zA-Z0-9\.]+[#[a-zA-Z0-9_\-]+)+]?$/)) { // If the version is a GitHub repository, compose the corresponding Git URL and do a Git checkout
        return new GitSource(baseDir, dependencyName, "git+https://github.com/"+versionSpec);
    } else if(parsedUrl.protocol == "file:") { // If the version is a file URL, simply compose a Nix path
        return new LocalSource(baseDir, dependencyName, outputDir, parsedUrl.path);
    } else if(versionSpec.substr(0, 3) == "../" || versionSpec.substr(0, 2) == "~/" || versionSpec.substr(0, 2) == "./" || versionSpec.substr(0, 1) == "/") { // If the version is a path, simply compose a Nix path
        return new LocalSource(baseDir, dependencyName, outputDir, versionSpec);
    } else {
        // In all other cases (valid or invalid semver range), just try the registry.
        // Sometimes invalid semver ranges are encountered or a tag has been provided (e.g. 'latest', 'unstable')
        return new NPMRegistrySource(baseDir, dependencyName, versionSpec, registries, stripOptionalDependencies);
    }
};

/**
 * Fetches the package metadata from the external source.
 *
 * @method
 * @param {function(String)} callback Callback that gets invoked when the work
 *     is done. In case of an error, it will set the first parameter to contain
 *     an error message.
 */
Source.prototype.fetch = function(callback) {
    callback("fetch() is not implemented, please use a prototype that inherits from Source");
};

/**
 * Takes a dependency object from a lock file and converts it into a source object.
 *
 * @param {Object} dependencyObj Dependency object from the lock file
 * @param {function(String)} callback Callback that gets invoked when the work
 *     is done. In case of an error, it will set the first parameter to contain
 *     an error message.
 */
Source.prototype.convertFromLockedDependency = function(dependencyObj, callback) {
    callback("convertFromLockedDependency() is not implemented, please use a prototype that inherits from Source");
};

/**
 * Converts NPM's integrity strings that have the following format:
 * <algorithm>-<base64 hash> to a hash representation that Nix understands.
 *
 * @method
 * @param {String} integrity NPM integrity string
 */
Source.prototype.convertIntegrityStringToNixHash = function(integrity) {
    if(integrity.substr(0, 5) === "sha1-") {
        var hash = base64js.toByteArray(integrity.substring(5));
        this.hashType = "sha1";
        this.sha1 = Buffer.from(hash).toString('hex');
    } else if(integrity.substr(0, 7) === "sha512-") {
        this.hashType = "sha512";
        this.sha512 = integrity.substring(7);
    } else {
        throw "Unknown integrity string: "+integrity;
    }
};

/**
 * @see NixASTNode#toNixAST
 */
Source.prototype.toNixAST = function() {
    return {
        name: this.config.name.replace("@", "_at_").replace("/", "_slash_"), // Escape characters from scoped package names that aren't allowed
        packageName: this.config.name,
        version: this.config.version
    };
};

exports.Source = Source;
