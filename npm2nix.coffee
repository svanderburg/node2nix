#!/usr/bin/env coffee
http = require 'http'
util = require 'util'
crypto = require 'crypto'

name = process.argv[2]

version = process.argv[3] ? "latest"

deps = []

hash = crypto.createHash 'sha256'

http.get "http://registry.npmjs.org/#{name}", (res) ->
  res.setEncoding()
  val = ""
  res.on 'data', (chunk) ->
    val += chunk
  res.on 'end', ->
    pkginfo = JSON.parse val
    version = pkginfo['dist-tags'].stable ? pkginfo['dist-tags'].latest if version is "latest"
    http.get "http://registry.npmjs.org/#{name}/-/#{name}-#{version}.tgz", (res) ->
      res.on 'data', (chunk) ->
        hash.update chunk
      res.on 'end', ->
        process.stdout.write """
                             "#{name}" = buildNodePackage rec {
                               name = "#{name}-#{version}";
                               src = fetchurl {
                                 url = "http://registry.npmjs.org/#{name}/-/${name}.tgz";
                                 sha256 = "#{hash.digest('hex')}";
                               };
                               deps = [ #{("self.\"#{dep}\"" for dep in deps).join " "} ];
                             };
                             """
    deps = (key for key, value of (pkginfo.versions[version].dependencies ? {}))
