http = require 'http'
crypto = require 'crypto'
events = require 'events'
url = require 'url'
util = require 'util'

semver = require 'semver'
RegistryClient = require 'npm-registry-client'

PackageFetcher = (cfg) ->
  unless this instanceof PackageFetcher
    new PackageFetcher cfg
  else
    events.EventEmitter.call this
    @_seen = {}
    @_pkginfos = {}
    this

PackageFetcher.prototype = Object.create events.EventEmitter.prototype,
  constructor: value: PackageFetcher

PackageFetcher.prototype.fetch = (name, spec, registry) ->
  spec = '*' if spec is 'latest' # ugh
  unless @_seen[name]?[spec]?
    @_seen[name] ?= {}
    @_seen[name][spec] = true
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

PackageFetcher.prototype._fetchFromRegistry = (name, spec, registry) ->
  handlePackage = (pkg) =>
    # !!! TODO: Handle optionalDependencies, peerDependencies
    deps = pkg.dependencies or {}
    registry = makeNewRegistry registry, pkg.registry if 'registry' of pkg
    for nm, dep of deps
      # !!! Seeming conflict between CommonJS Registry spec and npm on the one
      # hand and CommonJS Package spec on the other. Package spec allows deps
      # to be an object of options (e.g. "ssl": { "gnutls": "1.2.3", "openssl": "2.3.4" })
      # but npm only allows simple strings and Registry only allows version, registry
      # objects in addition to simple strings. Ignoring package spec until/unless a
      # registry entry in the wild shows up with that format
      if dep instanceof Object
        @fetch nm, dep.version, makeNewRegistry registry, dep.registry
      else
        @fetch nm, dep, registry
    unless pkg.dist.tarball?
      @emit 'error', "Could not find supported dist type for #{pkg.name}@#{pkg.version} in #{util.inspect pkg.dist}", name, spec
    else
      if pkg.dist.shasum? # Sometimes npm gives us shasums, how nice
        @emit 'fetched', name, spec, pkg
      else
        fetchUrl pkg.dist.tarball, (err, sha256sum) =>
          if err?
            @emit 'error', "Error getting hash of #{pkg.dist.tarball} for #{pkg.name}@#{pkg.version}: #{err}", name, spec
          else
            pkg.dist.sha256sum = sha256sum
            @emit 'fetched', name, spec, pkg

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

PackageFetcher.prototype._fetchFromHTTP = (name, spec, parsed) ->
  @emit 'error', "HTTP dependencies not yet supported", name, spec

PackageFetcher.prototype._fetchFromGit = (name, spec, parsed) ->
  @emit 'error', "git dependencies not yet supported", name, spec

fetchUrl = do ->
  cache = {}
  (u, callback) ->
    if cache[u]?
      callback undefined, cache[u]
    else
      parsed = url.parse u
      client = switch parsed.protocol
        when 'http:'
          http
        when 'https:'
          https
        else
          undefined
      unless client?
        callback "Unsupported protocol #{parsed.protocol}"
      else
        client.get u, (res) ->
          unless res.statusCode is 200
            callback "Unsuccessful status code while GETting #{u}: #{http.STATUS_CODES[res.statusCode]}"
          else
            res.on 'error', (err) -> callback "Error while GETting #{u}: #{err}"
            hash = crypto.createHash 'sha256'
            hash.on 'error', (err) ->
              callback "Error calculating hash for #{u}: #{err}"
            res.pipe hash
            hash.on 'readable', ->
              hashBuffer = hash.read 32
              if hashBuffer?
                hashString = hashBuffer.toString 'hex'
                cache[u] = hashString
                callback hashString

module.exports = PackageFetcher
