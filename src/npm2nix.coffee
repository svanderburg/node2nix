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
packageSet = {}

writePkg = finalizePkgs = undefined
do ->
  findCycles = (name, spec, pkg) ->
    index = 0
    node = { name: name, spec: spec }
    path = []
    indices= []
    pkg.cycles = []
    loop
      cycleDetected = false
      for el in path
        if el.name is node.name
          cycleDetected = true
          if el is path[0]
            pkg.cycles.push path.slice 1
      unless cycleDetected
        peerDeps = packageSet[node.name][node.spec].peerDependencies or {}
        if Object.keys(peerDeps).length > index
          path.push node
          indices.push index
          name = Object.keys(peerDeps)[index]
          node = { name: name, spec: peerDeps[name] }
          index = 0
          continue
        else if path.length is 0
          break
      node = path.pop()
      index = indices.pop() + 1
  cycleMembers = {}

  stream = fs.createWriteStream args.output
  stream.write "{ self, fetchurl, lib }:\n\n{"
  writePkg = (name, spec, pkg) ->
    if name of cycleMembers and spec of cycleMembers[name]
      stream.write """
      \n  full."#{escapeNixString name}"."#{escapeNixString spec}" = self.full."#{escapeNixString cycleMembers[name][spec].name}"."#{escapeNixString cycleMembers[name][spec].spec}";
      """
    else
      findCycles name, spec, pkg
      pkgs = [ pkg ]
      names = [ name ]
      specs = [ spec ]
      seen = {}
      seen[name] = true
      count = 0
      for cycle in pkg.cycles
        for node in cycle
          cycleMembers[node.name] ?= {}
          cycleMembers[node.name][node.spec] = { name: name, spec: spec }
          unless seen[node.name]
            pkgs.push packageSet[node.name][node.spec]
            names.push node.name
            specs.push node.spec
            count += 1
          seen[node.name] = true
      stream.write "\n  full.\"#{escapeNixString name}\".\"#{escapeNixString spec}\" = lib.makeOverridable self.buildNodePackage {"
      stream.write "\n    name = \"#{escapeNixString names[0]}-#{escapeNixString pkgs[0].version}\";\n    src = ["
      for idx in [0..count]
        pk = pkgs[idx]
        stream.write """
        \n      (#{if pk.patchLatest then 'self.patchLatest' else 'fetchurl'} {
                url = "#{pk.dist.tarball}";
                #{if 'shasum' of pk.dist then 'sha1' else 'sha256'} = "#{pk.dist.shasum ? pk.dist.sha256sum}";
              })
        """
      stream.write "\n    ];\n    buildInputs ="
      for idx in [0..count]
        stream.write "\n      "
        stream.write "++ " unless idx is 0
        stream.write "(self.nativeDeps.\"#{escapeNixString names[idx]}\".\"#{escapeNixString specs[idx]}\" or [])"
      stream.write ";\n    deps = ["
      seenDeps = {}
      for idx in [0..count]
        for nm, spc of pkgs[idx].dependencies or {}
          unless seenDeps[nm]
            spc = spc.version if spc instanceof Object
            if spc is 'latest' or spc is ''
              spc = '*'
            stream.write "\n      self.full.\"#{escapeNixString nm}\".\"#{escapeNixString spc}\""
          seenDeps[nm] = true
      stream.write "\n    ];\n    peerDependencies = ["
      for idx in [0..count]
        for nm, spc of pkgs[idx].peerDependencies or {}
          unless seenDeps[nm] or seen[nm]
            spc = spc.version if spc instanceof Object
            if spc is 'latest' or spc is ''
              spc = '*'
            stream.write "\n      self.full.\"#{escapeNixString nm}\".\"#{escapeNixString spc}\""
          seenDeps[nm] = true
      stream.write "\n    ];\n    passthru.names = [ #{("\"#{escapeNixString nm}\"" for nm in names).join " "} ];\n  };"

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

    pkgCount = 0
    fetcher.on 'fetching', ->
      pkgCount += 1
    fetcher.on 'fetched', (name, spec, pkg) ->
      pkgCount -= 1
      packageSet[name] ?= {}
      packageSet[name][spec] = pkg
      if pkgCount is 0
        names = (key for key, val of packageSet).sort()
        for name in names
          specs = (key for key, val of packageSet[name]).sort()
          for spec in specs
            writePkg name, spec, packageSet[name][spec]
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
