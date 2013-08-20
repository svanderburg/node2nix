fs = require 'fs'
path = require 'path'

argparse = require 'argparse'
npmconf = require 'npmconf'
RegistryClient = require 'npm-registry-client'

PackageFetcher = require './package-fetcher'

version = require('../package.json').version

parser = new argparse.ArgumentParser {
  version: version
  description: 'Generate nix expressions to build npm packages'
  epilog: """
      The package list can be either an npm package.json, in which case npm2nix
      will generate expressions for its dependencies, or a list of strings and
      at most one object, where the strings are package names and the object is
      a valid dependencies object (see npm.json(5) for details)
    """
}

parser.addArgument [ 'packageList' ],
  help: 'The file containing the packages to generate expressions for'
  type: path.resolve
  metavar: 'INPUT'

parser.addArgument [ 'output' ],
  help: 'The output file to generate'
  type: path.resolve
  metavar: 'OUTPUT'

args = parser.parseArgs()

escapeNixString = (string) ->
  string.replace /(\\|\$\{|")/g, "\\$&"

fullNames = {}

writePkg = finalizePkgs = undefined
do ->
  stream = fs.createWriteStream args.output
  stream.write "{ self, fetchurl, lib }:\n\n{"
  writePkg = (name, spec, pkg) ->
    stream.write """
    \n  full."#{escapeNixString name}"."#{escapeNixString spec}" = lib.makeOverridable self.buildNodePackage {
        name = "#{escapeNixString name}-#{escapeNixString pkg.version}";
        src = #{if pkg.patchLatest then "self.patchLatest" else "fetchurl"} {
          url = "#{pkg.dist.tarball}";
          #{if 'shasum' of pkg.dist then 'sha1' else 'sha256'} = "#{pkg.dist.shasum ? pkg.dist.sha256sum}";
        };
        buildInputs = self.nativeDeps."#{escapeNixString name}"."#{escapeNixString spec}" or [];
        deps = [
    """
    for nm, spc of pkg.dependencies or {}
      spc = spc.version if spc instanceof Object
      if spc is 'latest' or spc is ''
        spc = '*'
      stream.write "\n      self.full.\"#{escapeNixString nm}\".\"#{escapeNixString spc}\""
    stream.write "\n    ];"
    stream.write "\n    peerDependencies = ["
    for nm, spc of pkg.peerDependencies or {}
      spc = spc.version if spc instanceof Object
      stream.write "\n      self.full.\"#{escapeNixString nm}\".\"#{escapeNixString spc}\""
    stream.write "\n    ];"
    stream.write "\n  };"
    if fullNames[name] is spec
      stream.write """
      \n  "#{escapeNixString name}" = self.full."#{escapeNixString name}"."#{escapeNixString spec}";
      """
  finalizePkgs = ->
    stream.end "\n}\n"

npmconf.load (err, conf) ->
  if err?
    console.error "Error loading npm config: #{err}"
    process.exit 7
  registry = new RegistryClient conf
  fetcher = new PackageFetcher()
  fs.readFile args.packageList, (err, json) ->
    if err?
      console.error "Error reading file #{file}: #{err}"
      process.exit 1
    try
      packages = JSON.parse json
    catch error
      console.error "Error parsing JSON file #{file}: #{error}"
      process.exit 3

    do (packages) ->
      packages = {}
      pkgCount = 0
      fetcher.on 'fetching', ->
        pkgCount += 1
      fetcher.on 'fetched', (name, spec, pkg) ->
        pkgCount -= 1
        packages[name] ?= {}
        packages[name][spec] = pkg
        if pkgCount is 0
          strings = [ "[" ]
          names = (key for key, val of packages).sort()
          for name in names
            specs = (key for key, val of packages[name]).sort()
            for spec in specs
              writePkg name, spec, packages[name][spec]
          finalizePkgs()

    fetcher.on 'error', (err, name, spec) ->
      console.error "Error during fetch: #{err}"
      process.exit 8

    addPackage = (name, spec) ->
      spec = '*' if spec is 'latest' or spec is '' #ugh
      fullNames[name] = spec
      fetcher.fetch name, spec, registry
    if packages instanceof Array
      for pkg in packages
        if typeof pkg is "string"
          addPackage pkg, '*'
        else
          addPackage name, spec for name, spec of pkg
    else if packages instanceof Object
      unless 'dependencies' of packages or 'devDependencies' of packages
        console.error "#{file} specifies no dependencies"
        process.exit 6

      addPackage name, spec for name, spec of packages.dependencies ? {}
      addPackage name, spec for name, spec of packages.devDependencies ? {}
    else
      console.error "#{file} must represent an array of packages or be a valid npm package.json"
      process.exit 4
