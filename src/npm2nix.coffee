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

parser.addArgument [ '--overwrite' ],
  help: 'Whether to overwrite the helper default.nix expression (when generating for a package.json)',
  action: 'storeTrue',

args = parser.parseArgs()

escapeNixString = (string) ->
  string.replace /(\\|\$\{|")/g, "\\$&"

fullNames = {}
packageSet = {}

writePkg = finalizePkgs = undefined
do ->
  index = 0
  stack = []
  strongConnect = (pkg) ->
    pkg.tarjanIndex = index
    pkg.tarjanLowLink = index
    index += 1
    stackIndex = stack.length
    stack.push pkg

    peerDeps = pkg.peerDependencies or {}
    for name, spec of peerDeps
      otherPkg = packageSet[name][spec]

      unless 'tarjanIndex' of otherPkg
        strongConnect otherPkg
        pkg.tarjanLowLink = otherPkg.tarjanLowLink if otherPkg.tarjanLowLink < pkg.tarjanLowLink
      else
        if otherPkg in stack
          pkg.tarjanLowLink = otherPkg.tarjanIndex if otherPkg.tarjanIndex < pkg.tarjanLowLink

    if pkg.tarjanLowLink is pkg.tarjanIndex
      pkg.scc = stack[stackIndex..]
      stack = stack[...stackIndex]


  known = {}

  stream = fs.createWriteStream args.output
  stream.write "{ self, fetchurl, fetchgit ? null, lib }:\n\n{"
  writePkg = (name, spec, pkg) ->
    stream.write """
    \n  by-spec.\"#{escapeNixString name}\".\"#{escapeNixString spec}\" =
        self.by-version.\"#{escapeNixString name}\".\"#{escapeNixString  pkg.version}\";
    """
    unless name of known and pkg.version of known[name]
      known[name] ?= {}
      known[name][pkg.version] = true
      unless 'tarjanIndex' of pkg
        strongConnect pkg
      if 'scc' of pkg
        names = [ ]
        count = -1
        cycleDeps = {}
        for pk in pkg.scc
          unless name of known and pk.version of known[name]
            stream.write """
            \n  by-version."#{escapeNixString pk.name}"."#{escapeNixString pk.version}" = self.by-version."#{escapeNixString name}"."#{escapeNixString pkg.version}";
            """
            known[pk.name] ?= {}
            known[pk.name][pk.version] = true
          names.push pk.name
          cycleDeps[pk.name] = true
          count += 1

        stream.write "\n  by-version.\"#{escapeNixString name}\".\"#{escapeNixString pkg.version}\" = lib.makeOverridable self.buildNodePackage {"
        stream.write "\n    name = \"#{escapeNixString names[0]}-#{escapeNixString pkg.scc[0].version}\";\n    src = ["
        for idx in [0..count]
          pk = pkg.scc[idx]
          if 'tarball' of pk.dist
            stream.write """
            \n      (#{if pk.needsPatch then 'self.patchSource fetchurl' else 'fetchurl'} {
                    url = "#{pk.dist.tarball}";
                    name = "#{pk.name}-#{pk.version}.tgz";
                    #{if 'shasum' of pk.dist then 'sha1' else 'sha256'} = "#{pk.dist.shasum ? pk.dist.sha256sum}";
                  })
            """
          else
            stream.write """
            \n      (#{if pk.needsPatch then 'self.patchSource fetchgit' else 'fetchgit'} {
                    url = "#{pk.dist.git}";
                    rev = "#{pk.dist.rev}";
                    sha256 = "#{pk.dist.sha256sum}";
                  })
            """
        stream.write "\n    ];\n    buildInputs ="
        for idx in [0..count]
          stream.write "\n      "
          stream.write "++ " unless idx is 0
          stream.write "(self.nativeDeps.\"#{escapeNixString names[idx]}\" or [])"
        stream.write ";\n    deps = ["
        seenDeps = {}
        for idx in [0..count]
          for nm, spc of pkg.scc[idx].dependencies or {}
            unless seenDeps[nm]
              spc = spc.version if spc instanceof Object
              if spc is 'latest' or spc is ''
                spc = '*'
              stream.write "\n      self.by-version.\"#{escapeNixString nm}\".\"#{packageSet[nm][spc].version}\""
            seenDeps[nm] = true
        stream.write "\n    ];\n    peerDependencies = ["
        for idx in [0..count]
          for nm, spc of pkg.scc[idx].peerDependencies or {}
            unless seenDeps[nm] or cycleDeps[nm]
              spc = spc.version if spc instanceof Object
              if spc is 'latest' or spc is ''
                spc = '*'
              stream.write "\n      self.by-version.\"#{escapeNixString nm}\".\"#{packageSet[nm][spc].version}\""
            seenDeps[nm] = true
        stream.write "\n    ];\n    passthru.names = [ #{("\"#{escapeNixString nm}\"" for nm in names).join " "} ];\n  };"

    if fullNames[name] is spec
      stream.write """
      \n  "#{escapeNixString name}" = self.by-version."#{escapeNixString name}"."#{pkg.version}";
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
      console.error "Error reading file #{args.packageList}: #{err}"
      process.exit 1
    try
      packages = JSON.parse json
    catch error
      console.error "Error parsing JSON file #{args.packageList}: #{error}"
      process.exit 3

    packageByVersion = {}
    pkgCount = 0
    fetcher.on 'fetching', ->
      pkgCount += 1
    fetcher.on 'fetched', (name, spec, pkg) ->
      pkgCount -= 1
      packageByVersion[name] ?= {}
      unless pkg.version of packageByVersion[name]
        packageByVersion[name][pkg.version] = pkg
      packageSet[name] ?= {}
      packageSet[name][spec] = packageByVersion[name][pkg.version]
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

      pkgName = escapeNixString packages.name
      fs.writeFile "default.nix", """
        { #{pkgName} ? { outPath = ./.; name = "#{pkgName}"; }
        }:
        let
          pkgs = import <nixpkgs> {};
          nodePackages = import <nixpkgs/pkgs/top-level/node-packages.nix> {
            inherit pkgs;
            inherit (pkgs) stdenv nodejs fetchurl fetchgit;
            neededNatives = [ pkgs.python ] ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
            self = nodePackages;
            generated = ./#{path.relative process.cwd(), args.output};
          };
        in rec {
          tarball = pkgs.runCommand "#{pkgName}-#{packages.version}.tgz" { buildInputs = [ pkgs.nodejs ]; } ''
            mv `HOME=$PWD npm pack ${#{pkgName}}` $out
          '';
          build = nodePackages.buildNodePackage {
            name = "#{pkgName}-#{packages.version}";
            src = [ tarball ];
            buildInputs = nodePackages.nativeDeps."#{pkgName}" or [];
            deps = [ #{
              ("nodePackages.by-spec.\"#{escapeNixString nm}\".\"#{escapeNixString spc}\"" for nm, spc of (packages.dependencies ? {})).join ' '
            } ];
            peerDependencies = [];
            passthru.names = [ "#{pkgName}" ];
          };
        }
        """, flag: "w#{if args.overwrite then '' else 'x'}", (err) ->
          if err? and err.code isnt 'EEXIST'
            console.error "Error writing helper default.nix: #{err}"
    else
      console.error "#{file} must represent an array of packages or be a valid npm package.json"
      process.exit 4
