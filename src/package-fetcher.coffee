http = require 'http'
https = require 'https'
crypto = require 'crypto'
zlib = require 'zlib'
events = require 'events'
url = require 'url'
util = require 'util'

tar = require 'tar'
semver = require 'semver'
RegistryClient = require 'npm-registry-client'

PackageFetcher = (cfg) ->
  unless this instanceof PackageFetcher
    new PackageFetcher cfg
  else
    events.EventEmitter.call this
    @_peerDependencies = {}
    this

PackageFetcher.prototype = Object.create events.EventEmitter.prototype,
  constructor: value: PackageFetcher

PackageFetcher.prototype.fetch = (name, spec, registry) ->
  spec = '*' if spec is 'latest' # ugh
  unless 'name' of @_peerDependencies and 'spec' of @_peerDependencies[name]
    @_peerDependencies[name] ?= {}
    @_peerDependencies[name][spec] = []
    @emit 'fetching', name, spec
    if semver.validRange spec
      @_fetchFromRegistry name, spec, registry
    else
      parsed = url.parse spec
      switch parsed.protocol
        when 'git:', 'git+ssh:', 'git+http:', 'git+https:'
          @_fetchFromGit name, spec, registry, parsed
        when 'http:', 'https:'
          @_fetchFromHTTP name, spec, registry, parsed
        else
          @emit 'error', "Unknown spec #{spec}", name, spec

PackageFetcher.prototype._fetchFromRegistry = (name, spec, registry) ->
  handlePackage = (pkg) =>
    unless pkg.dist.tarball?
      @emit 'error', "Could not find supported dist type for #{pkg.name}@#{pkg.version} in #{util.inspect pkg.dist}", name, spec
    else
      if pkg.dist.shasum? # Sometimes npm gives us shasums, how nice
        @_havePackage name, spec, pkg, registry
        @emit 'fetched', name, spec, pkg
      else
        @_fetchFromHTTP name, spec, registry, url.parse dist.tarball

  registry.get "/#{encodeURIComponent name}", (err, info) =>
    if err?
      @emit 'error', "Error getting registry info for #{name}: #{err}", name, spec
    else
      version = semver.maxSatisfying (key for key, value of info.versions), spec
      unless version?
        @emit 'error', "Could not find version matching #{spec} for #{name} in #{util.inspect info.versions}", name, spec
      else
        pkg = info.versions[version]
        if pkg instanceof Object
          handlePackage pkg
        else
          registry.get "/#{encodeURIComponent name}/#{version}", (err, info) =>
            if err?
              @emit 'error', "Error getting package info for #{name}@#{version}: #{err}", name, spec
            else
              handlePackage info

do ->
  cache = {}

  addFetchedCallback = (cached, cb) ->
    if 'err' of cached
      cb cached.err
    else if 'pkg' of cached
      cb undefined, cached.pkg
    else
      cached.callbacks.push cb

  PackageFetcher.prototype._fetchFromHTTP = (name, spec, registry, parsed) ->
    href = parsed.href
    callback = (err, pkg) =>
      if err?
        @emit 'error', "Error fetching #{href}: #{err}", name, spec
      else
        @emit 'fetched', name, spec, pkg
    if href of cache
      addFetchedCallback cache[href], callback
    else
      cached = callbacks: [ callback ]
      cache[href] = cached
      error = (err) ->
        unless 'err' of cached
          cached.err = err
          cb err for cb in cached.callbacks

      client = switch parsed.protocol
        when 'http:'
          http
        when 'https:'
          https
        else
          undefined
      unless client?
        error "Unsupported protocol #{parsed.protocol}"
      else
        unzip = zlib.createGunzip()
        computeHash = crypto.createHash 'sha256'
        tarParser = new tar.Parse()

        unzip.pipe tarParser

        unzip.on 'error', (err) -> error "Error while unzipping #{href}: #{err}"

        computeHash.on 'error', (err) -> error "Error while computing hash of #{href}: #{err}"

        tarParser.on 'error', (err) -> error "Error while parsing tarball unzipped from #{href}: #{err}"

        redirectCount = 0
        getCallback = (res) =>
          unless res.statusCode is 200
            if res.statusCode in [ 300, 301, 302, 303, 307, 308 ]
              redirectCount += 1
              if redirectCount > 5
                error "Unable to GET #{href}: Too many redirects"
              else unless 'location' of res.headers
                error "Bad HTTP response while GETting #{href}: Redirect with no Location header"
              else
                client.get res.headers.location, getCallback
            else
              error "Unsuccessful status code while GETting #{href}: #{http.STATUS_CODES[res.statusCode]}"
          else
            res.on 'error', (err) -> error "Error while GETting #{href}: #{err}"

            tee = ->
              while (chunk = res.read()) isnt null
                unzip.write chunk
                computeHash.write chunk
            res.on 'readable', tee
            endComputeHash = -> computeHash.end()
            res.on 'end', endComputeHash

            earlyEnd = -> error "No package.json found in #{href}"
            tarParser.on 'end', earlyEnd

            pkg = null
            hashBuf = null
            finished = ->
              pkg.dist = { tarball: href, sha256sum: hashBuf.toString 'hex' }
              cached.pkg = pkg
              cb undefined, pkg for cb in cached.callbacks

            computeHash.on 'readable', ->
              hashBuf = computeHash.read 32
              finished() unless hashBuf is null or pkg is null

            tarParser.on 'entry', (entry) =>
              if /^[^/]*\/package\.json$/.test entry.path
                chunks = []
                length = 0

                entry.on 'data', (chunk) ->
                  chunks.push chunk
                  length += chunk.length

                entry.on 'end', =>
                  pkg = JSON.parse Buffer.concat(chunks, length).toString()
                  @_havePackage name, spec, pkg, registry
                  chunks = null
                  unzip.unpipe tarParser
                  unzip.end()
                  # tarParser doesn't like this...
                  # tarParser.end()
                  res.removeListener 'readable', tee
                  res.removeListener 'end', endComputeHash
                  tarParser.removeListener 'end', earlyEnd
                  res.pipe computeHash
                  finished() unless hashBuf is null

        client.get href, getCallback
PackageFetcher.prototype._fetchFromGit = (name, spec, parsed) ->
  @emit 'error', "git dependencies not yet supported", name, spec

do ->
  makeNewRegistry = (registry, newUrl) ->
    # uuugh
    cfg = do ->
      deleted = {}
      # !!! Shared cache dir, is that OK? Uses etags so probably
      local = registry: newUrl
      baseCfg = registry.config
      get: (key) ->
        if key of local
          local[key]
        else if key of deleted
          undefined
        else
          baseCfg.get key
      set: (key, value) -> local[key] = value
      del: (k) -> deleted[key] = true; delete local[key]
    new RegistryClient cfg

  tryMergeDeps = (dep1, dep2) ->
    if dep1 instanceof Object
      dep1 = dep1.version
    if dep2 instanceof Object
      dep2 = dep2.version
    if semver.validRange(dep1) and semver.validRange(dep2)
      merged = new semver.Range dep1
      range2 = new semver.Range dep2
      mergedSet = []
      for left in merged.set
        for right in range2.set
          subset = left.concat(right)
          subset.splice(left.length - 1, 1)
          mergedSet.push subset
      merged.set = mergedSet
      merged.format()
    else
      undefined

  PackageFetcher.prototype._handleDeps = (pkg, registry) ->
    # !!! TODO: Handle optionalDependencies, peerDependencies
    registry = makeNewRegistry registry, pkg.registry if 'registry' of pkg
    pkg.patchLatest = false
    handleDep = (nm, dep) =>
      # !!! Seeming conflict between CommonJS Registry spec and npm on the one
      # hand and CommonJS Package spec on the other. Package spec allows deps
      # to be an object of options (e.g. "ssl": { "gnutls": "1.2.3", "openssl": "2.3.4" })
      # but npm only allows simple strings and Registry only allows version, registry
      # objects in addition to simple strings. Ignoring package spec until/unless a
      # registry entry in the wild shows up with that format
      thisRegistry = registry
      if dep instanceof Object
        thisRegistry = makeNewRegistry registry, dep.registry
        dep = dep.version
      if dep is 'latest'
        pkg.patchLatest = true
        dep = '*'
      @fetch nm, dep, thisRegistry
    for nm, dep of pkg.dependencies or {}
      handleDep nm, dep
    for nm, dep of pkg.peerDependencies or {}
      handleDep nm, dep
    for nm, dep of pkg.dependencies or {}
      if dep instanceof Object
        dep = dep.version
      if dep is 'latest'
        dep = '*'
      @_getPeerDependencies nm, dep, (peerDependencies) =>
        for nm, dep of peerDependencies
          if dep is 'latest'
            dep = '*'
            pkg.patchLatest = true
          if nm of pkg.dependencies
            merged = tryMergeDeps dep, pkg.dependencies[nm]
            if merged?
              dep = merged
            else
              @emit 'error',
                "Cannot merge top-level dependency #{nm}: #{pkg.dependencies[nm]} of #{name}@#{pkg.version} with peerDependency #{nm}: #{dep} since both are not valid semver ranges",
                name,
                pkg.version
              return
          handleDep nm, dep
          pkg.dependencies[nm] = dep

PackageFetcher.prototype._havePackage = (name, spec, pkg, registry) ->
  peerDependencies = pkg.peerDependencies ? {}
  cb peerDependencies for cb in @_peerDependencies[name][spec]
  @_peerDependencies[name][spec] = peerDependencies
  @_handleDeps pkg, registry

PackageFetcher.prototype._getPeerDependencies = (name, spec, callback) ->
  if @_peerDependencies[name][spec] instanceof Array
    @_peerDependencies[name][spec].push callback
  else
    callback @_peerDependencies[name][spec]

module.exports = PackageFetcher
