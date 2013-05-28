http = require 'http'
crypto = require 'crypto'
semver = require 'semver'

knownExprs = {}

generatePackage = (name, range, callback) ->
  # Avoid dependency cycles
  knownExprs["#{name}-#{range}"] = {}
  #!!! TODO: Handle the non npmjs.org case
  http.get "http://registry.npmjs.org/#{name}", (res) ->
    res.setEncoding "utf8"
    readInfo = ->
      json = res.read res.headers['content-length']
      if json?
        pkginfo = JSON.parse json
        versions = (key for own key, value of pkginfo.versions)
        version = semver.maxSatisfying versions, range
        deps = pkginfo.versions[version].dependencies ? {}
        patchLatest = false
        for nm, ver of deps
          if ver == 'latest'
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
          hash = crypto.createHash 'sha256'
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
