http = require 'http'
https = require 'https'
crypto = require 'crypto'
zlib = require 'zlib'
events = require 'events'
url = require 'url'
util = require 'util'
child_process = require 'child_process'
path = require 'path'
os = require 'os'

temp = require 'temp'
temp.track()

fs = require 'fs.extra'
findit = require 'findit'
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
  unless name of @_peerDependencies and spec of @_peerDependencies[name]
    @_peerDependencies[name] ?= {}
    @_peerDependencies[name][spec] = []
    @emit 'fetching', name, spec
    parsed = url.parse spec
    switch parsed.protocol
      when 'git:', 'git+ssh:', 'git+http:', 'git+https:'
        @_fetchFromGit name, spec, registry, parsed
      when 'http:', 'https:'
        @_fetchFromHTTP name, spec, registry, parsed
      else
        if semver.validRange spec, true
          @_fetchFromRegistry name, spec, registry
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
      version = semver.maxSatisfying (key for key, value of info.versions), spec, true
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
          cached.callbacks = []

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
              cached.callbacks = []

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
do ->
  cache = {}

  addFetchedCallback = (cached, cb) ->
    if 'err' of cached
      cb cached.err
    else if 'pkg' of cached
      cb undefined, cached.pkg
    else
      cached.callbacks.push cb

  PackageFetcher.prototype._fetchFromGit = (name, spec, registry, parsed) ->
    parsed.protocol = switch parsed.protocol
        when 'git:'
          'git:'
        when 'git+ssh:'
          'ssh:'
        when 'git+http:'
          'http:'
        when 'git+https:'
          'https:'
    href = parsed.format()
    callback = (err, pkg) =>
      if err?
        @emit 'error', "Error fetching #{href} from git: #{err}", name, spec
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
          cached.callbacks = []
      commitIsh = if parsed.hash?
        parsed.hash.slice 1
      else
        'master'
      parsed.hash = null
      temp.mkdir { dir: os.tmpDir(), prefix: "npm2nix-git-checkout-#{name}" }, (err, dirPath) =>
        if err?
          error "Error creating temporary directory for git checkout: #{err}"
        else
          oldError = error
          error = (err) ->
            fs.rmrf dirPath, ->
            oldError err
          gitClone = child_process.spawn "git", [ "clone", parsed.format() ], cwd: dirPath, stdio: "inherit"
          gitClone.on 'error', (err) -> error "Error executing git clone: #{err}"
          gitClone.on 'exit', (code, signal) =>
            unless code?
              error "git clone died with signal #{signal}"
            else unless code is 0
              error "git clone exited with non-zero status code #{code}"
            else
              fs.readdir dirPath, (err, files) =>
                if err?
                  error "Error reading directory #{dirPath}: #{err}"
                else
                  if files.length isnt 1
                    error "git clone did not create exactly one directory"
                  else
                    pkg = null
                    hash = null
                    rev = null
                    finished = ->
                      fs.rmrf dirPath, ->
                      pkg.dist = { git: parsed.format(), rev: rev, sha256sum: hash }
                      cached.pkg = pkg
                      cb undefined, pkg for cb in cached.callbacks
                      cached.callbacks = []

                    gitDir = "#{dirPath}/#{files[0]}"
                    gitRevParse = child_process.spawn "git", [ "rev-parse", commitIsh ], cwd: gitDir, stdio: [ 0, 'pipe', 2 ]
                    gitRevParse.on 'error', (err) -> error "Error executing git rev-parse: #{err}"
                    gitRevParse.on 'exit', (code, signal) =>
                      unless code?
                        error "git rev-parse died with signal #{signal}"
                      else unless code is 0
                        error "git rev-parse exited with non-zero status code #{code}"
                    gitRevParse.stdout.setEncoding "utf8"
                    readRev = ->
                      rev = gitRevParse.stdout.read 40
                      if rev?
                        gitRevParse.stdout.removeListener 'readable', readRev
                        gitRevParse.stdout.removeListener 'end', earlyRevEnd
                        gitRevParse.stdout.on 'data', ->
                        finished() if pkg? and hash?
                    gitRevParse.stdout.on 'readable', readRev
                    readRev()
                    earlyRevEnd = ->
                      error "git rev-parse's stdout ended before 64 characters were read"
                    gitRevParse.stdout.on 'end', earlyRevEnd

                    gitCheckout = child_process.spawn "git", [ "checkout", commitIsh ], cwd: gitDir, stdio: "inherit"
                    gitCheckout.on 'error', (err) -> error "Error executing git checkout: #{err}"
                    gitCheckout.on 'exit', (code, signal) =>
                      unless code?
                        error "git checkout died with signal #{signal}"
                      else unless code is 0
                        error "git checkout exited with non-zero status code #{code}"
                      else
                        fs.readFile "#{gitDir}/package.json", encoding: "utf8", (err, data) =>
                          if err?
                            error "Error reading package.json in #{parsed.format()}##{commitIsh} clone: #{err}"
                          else
                            pkg = JSON.parse data
                            @_havePackage name, spec, pkg, registry
                            finished() if hash? and rev?
                        finder = findit gitDir
                        dotGitRegexp = /^\.git.*$/
                        deletesLeft = 1
                        deleteFinished = ->
                          deletesLeft -= 1
                          finder.emit 'noMoreDeletes' if deletesLeft is 0
                        finder.on 'directory', (dir, stat, stop) ->
                          if dotGitRegexp.test path.basename(dir)
                            stop()
                            deletesLeft += 1
                            fs.rmrf dir, (err) ->
                              if err?
                                error "Error removing directory #{dir} in #{parsed.format()}##{commitIsh} clone: #{err}"
                              else
                                deleteFinished()
                        finder.on 'file', (file) ->
                          if dotGitRegexp.test path.basename(file)
                            deletesLeft += 1
                            fs.unlink file, (err) ->
                              if err?
                                error "Error unlinking file #{file} in #{parsed.format()}##{commitIsh} clone: #{err}"
                              else
                                deleteFinished()
                        finder.on 'link', (link) ->
                          if dotGitRegexp.test path.basename(link)
                            deletesLeft += 1
                            fs.unlink link, (err) ->
                              if err?
                                error "Error unlinking symlink #{link} in #{parsed.format()}##{commitIsh} clone: #{err}"
                              else
                                deleteFinished()
                        finder.on 'error', (err) ->
                          error "Error walking git tree to remove .git* files: #{err}"
                        finder.on 'end', deleteFinished
                        finder.once 'noMoreDeletes', ->
                          nixHash = child_process.spawn "nix-hash", [ "--type", "sha256", gitDir ], stdio: [ 0, 'pipe', 2 ]
                          nixHash.on 'error', (err) -> error "Error executing nix-hash: #{err}"
                          nixHash.stdout.setEncoding "utf8"
                          nixHash.on 'exit', (code, signal) ->
                            unless code?
                              error "nix-hash died with signal #{signal}"
                            else unless code is 0
                              error "nix-hash exited with non-zero status code #{code}"
                          readHash = ->
                            hash = nixHash.stdout.read 64
                            if hash?
                              nixHash.stdout.removeListener 'readable', readHash
                              nixHash.stdout.removeListener 'end', earlyHashEnd
                              nixHash.stdout.on 'data', ->
                              finished() if pkg? and rev?
                          nixHash.stdout.on 'readable', readHash
                          readHash()
                          earlyHashEnd = ->
                            error "nix-hash's stdout ended before 64 characters were read"
                          nixHash.stdout.on 'end', earlyHashEnd

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
    if dep1 is 'latest' or dep1 is ''
      dep1 = '*'
    if dep2 is 'latest' or dep2 is ''
      dep2 = '*'
    if semver.validRange(dep1, true) and semver.validRange(dep2, true)
      merged = new semver.Range dep1, true
      range2 = new semver.Range dep2, true
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
    pkg.needsPatch = false
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
        pkg.needsPatch = true
        dep = '*'
      if dep is ''
        dep = '*'
      parsed = url.parse dep
      if parsed.protocol in [ 'git:', 'git+ssh:', 'git+http:', 'git+https:' ]
        pkg.needsPatch = true
      @fetch nm, dep, thisRegistry
    for nm, dep of pkg.dependencies or {}
      handleDep nm, dep
    for nm, dep of pkg.peerDependencies or {}
      handleDep nm, dep

    handlePeerDependencies = (peerDependencies) =>
      peerDeps = {}
      for nm, dep of peerDependencies
        if dep instanceof Object
          dep = dep.version
        if dep is 'latest'
          dep = '*'
          pkg.needsPatch = true
        if dep is ''
          dep = '*'
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
        peerDeps[nm] = dep
      for nm, dep of peerDeps
        @_getPeerDependencies nm, dep, handlePeerDependencies

    for nm, dep of pkg.dependencies or {}
      if dep instanceof Object
        dep = dep.version
      if dep is 'latest' or dep is ''
        dep = '*'
      @_getPeerDependencies nm, dep, handlePeerDependencies

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
