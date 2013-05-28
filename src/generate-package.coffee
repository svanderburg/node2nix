http = require 'http'
crypto = require 'crypto'
semver = require 'semver'

knownExprs = {}

generatePackage = (name, range, callback) ->
  # Avoid dependency cycles
  if "#{name}-#{range}" in knownExprs
    callback knownExprs
    return
  knownExprs["#{name}-#{range}"] = true

  error = (str) ->
    knownExprs["#{name}-#{range}"] = str
    callback knownExprs

  #!!! TODO: Handle the non npmjs.org case
  http.get "http://registry.npmjs.org/#{name}", (res) ->
    unless res.statusCode is 200
      return error "Failed to get package info for #{name}: #{http.STATUS_CODES[res.statusCode]}"
    res.on 'error', (err) ->
      error "Error getting package info for #{name}: #{err}"
    res.setEncoding "utf8"
    readInfo = ->
      json = res.read res.headers['content-length']
      if json?
        try
          pkginfo = JSON.parse json
        catch error
          return error "Error parsing pkginfo for #{name} as JSON: #{error}"
        unless pkginfo.versions? and pkginfo.versions instanceof Object
          return error "Package info for #{name} has missing or improper versions field"

        versions = (key for own key, value of pkginfo.versions)
        version = semver.maxSatisfying versions, range
        unless version?
          return error "Could not find version matching #{range} for #{name} in #{JSON.stringify versions}"
        deps = pkginfo.versions[version].dependencies ? {}
        unless deps instanceof Object
          return error "Non-object dependencies field for version #{version} of #{name}"
        patchLatest = false
        for nm, ver of deps
          if ver is 'latest'
            deps[nm] = '*'
            patchLatest = true
        pkgCount = 1 # in the no dependency case, there is one package to add
        finishedCallback = ->
          pkgCount -= 1
          if pkgCount is 0
            callback knownExprs
        for nm, ver of deps
          unless knownExprs["#{nm}-#{ver}"]
            pkgCount += 1
            generatePackage nm, ver, finishedCallback
        http.get "http://registry.npmjs.org/#{name}/-/#{name}-#{version}.tgz", (res) ->
          unless res.statusCode is 200
            return error "Failed to get tarball for #{name}-#{version}: #{http.STATUS_CODES[res.statusCode]}"
          res.on 'error', (err) ->
            error "Error getting tarball for #{name}-#{version}: #{err}"
          hash = crypto.createHash 'sha256'
          hash.on 'error', (err) ->
            error "Error getting hash for #{name}-#{version}: #{err}"
          readHash = ->
            hashBuffer = hash.read 32
            if hashBuffer?
              knownExprs["#{name}-#{range}"] =
                hash: hashBuffer
                patchLatest: patchLatest
                dependencies: deps
                version: version
                name: name
              finishedCallback()
          res.pipe hash
          hash.on 'readable', readHash
          readHash()
    res.on 'readable', readInfo
    readInfo()

module.exports = generatePackage
