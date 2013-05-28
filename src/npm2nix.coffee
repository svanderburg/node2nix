fs = require 'fs'
generatePackage = require './generate-package'

file = process.argv[2]

unless file?
  console.error "Usage: #{process.argv[1]} PACKAGES_FILE"
  process.exit 1

escapeNixString = (string) ->
  string.replace /(\\|\$\{|")/g, "\\$&"

fs.readFile file, (err, json) ->
  if err?
    console.error "Error reading file #{file}: #{err}"
    process.exit 2
  try
    packages = JSON.parse json
  catch error
    console.error "Error parsing JSON file #{file}: #{error}"
    process.exit 3

  unless packages instanceof Array
    console.error "#{file} must represent an array of packages"
    process.exit 4

  pkgCount = packages.length
  generateCallback = (packages) ->
    pkgCount -= 1
    if pkgCount is 0
      strings = [ "[" ]
      for fullName, pkg of packages
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
                dependencies = [
          """
          for nm, rng of pkg.dependencies
            strings.push "    { name = \"#{escapeNixString nm}\"; range = \"#{escapeNixString rng}\"; }"
          strings.push "  ];\n  }"
      console.log(strings.join("\n  ") + "\n]")

  for pkg in packages
    unless 'name' of pkg
      console.error "Each package must have a name, but #{JSON.stringify pkg} doesn't"
      process.exit 5
    range = pkg.range ? "*"
    generatePackage pkg.name, range, generateCallback
