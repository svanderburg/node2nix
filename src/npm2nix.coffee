fs = require 'fs'
path = require 'path'
argparse = require 'argparse'
generatePackage = require './generate-package'

version = require('../package.json').version

parser = new argparse.ArgumentParser {
  version: version
  description: 'Generate nix expressions to build npm packages'
  epilog: """
      The package list can be either an npm package.json, in which case npm2nix
      will generate expressions for its dependencies, or a list of strings and
      objects, where the strings are interpreted as package names and the objects
      must have key `name', representing the package name and may have key
      `range', representing the acceptible version range in a format understood
      by the semver module
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

fs.readFile args.packageList, (err, json) ->
  if err?
    console.error "Error reading file #{file}: #{err}"
    process.exit 1
  try
    packages = JSON.parse json
  catch error
    console.error "Error parsing JSON file #{file}: #{error}"
    process.exit 3

  generateCallback = (packages) ->
    pkgCount -= 1
    if pkgCount is 0
      strings = [ "[" ]
      keys = (key for key, val of packages).sort()
      for fullName in keys
        pkg = packages[fullName]
        if pkg is true
          console.error "Internal error: Package #{fullName} never filled in, "
          process.exit 6
        # !!! instanceof String returns false for strings from literals, WHAT?
        if typeof pkg is "string"
          console.error "Error getting package info for #{fullName}: #{pkg}"
        else
          strings.push """
            {
                baseName = \"#{escapeNixString pkg.name}\";
                version = \"#{escapeNixString pkg.version}\";
                fullName = \"#{escapeNixString fullName}\";
                hash = \"#{escapeNixString pkg.hash.toString 'hex'}\";
                patchLatest = #{if pkg.patchLatest then 'true' else 'false'};
                topLevel = #{if fullName of fullNames then 'true' else 'false'};
                dependencies = [
          """
          for nm, rng of pkg.dependencies
            strings.push "    { name = \"#{escapeNixString nm}\"; range = \"#{escapeNixString rng}\"; }"
          strings.push "  ];\n  }"
      fs.writeFileSync args.output, strings.join("\n  ") + "\n]"

  if packages instanceof Array
    pkgCount = packages.length

    for pkg in packages
      if typeof pkg is "string"
        name = pkg
        range = "*"
      else
        unless 'name' of pkg
          console.error "Each package must have a name, but #{JSON.stringify pkg} doesn't"
          process.exit 5
        name = pkg.name
        range = pkg.range ? "*"
      fullNames["#{name}-#{range}"] = true
      generatePackage name, range, generateCallback
  else if packages instanceof Object
    unless 'dependencies' of packages or 'devDependencies' of packages
      console.error "#{file} specifies no dependencies"
      process.exit 7

    unless not ('dependencies' of packages) or packages.dependencies instanceof Object
      console.error "#{file} has an invalid dependencies field"
      process.exit 7

    unless not ('devDependencies' of packages) or packages.devDependencies instanceof Object
      console.error "#{file} has an invalid devDependencies field"
      process.exit 8

    pkgCount = 0
    addPackage = (name, range) ->
      pkgCount += 1
      range = '*' if range is 'latest' #ugh
      fullNames["#{name}-#{range}"] = true
      generatePackage name, range, generateCallback
    addPackage name, range for name, range of packages.dependencies ? {}
    addPackage name, range for name, range of packages.devDependencies ? {}

  else
    console.error "#{file} must represent an array of packages or be a valid npm packages.json"
    process.exit 4
