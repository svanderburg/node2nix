/**
 * Construct a new deployment config instance.
 *
 * @class DeploymentConfig
 * @classdesc Stores all global deployment configuration properties
 *
 * @constructor
 * @param {Array<Registry>} registries An array of alternative registries for scoped packages
 * @param {Boolean} production Indicates whether we deploy in production mode or
 *     development mode. In development mode, also the development dependencies
 *     will be included.
 * @param {Boolean} includePeerDependencies Indicates whether to include peer dependencies with the package
 * @param {Boolean} flatten Indicates whether to create a flat dependency structure in which dependencies are as high as possible in the graph
 * @param {String} nodePackage Name of the Node.js package to use from Nixpkgs
 * @param {String} outputDir Directory in which the nix expression will be written
 * @param {Boolean} bypassCache Indicates that the content addressable cache should be bypassed
 * @param {Boolean} stripOptionalDependencies When enabled, the optional dependencies are stripped from the regular dependencies in the NPM registry
 */
function DeploymentConfig(registries, production, includePeerDependencies, flatten, nodePackage, outputDir, bypassCache, stripOptionalDependencies) {
    this.registries = registries;
    this.production = production;
    this.includePeerDependencies = includePeerDependencies;
    this.flatten = flatten;
    this.nodePackage = nodePackage;
    this.outputDir = outputDir;
    this.bypassCache = bypassCache;
    this.stripOptionalDependencies = stripOptionalDependencies;
}

exports.DeploymentConfig = DeploymentConfig;
