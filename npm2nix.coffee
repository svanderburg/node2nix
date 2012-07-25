#!/usr/bin/env coffee
http = require 'http'
util = require 'util'
crypto = require 'crypto'

name = process.argv[process.argv.length - 1]

version = ""

deps = []

hash = crypto.createHash 'sha256'

http.get "http://registry.npmjs.org/#{name}", (res) ->
  res.setEncoding()
  val = ""
  res.on 'data', (chunk) ->
    val += chunk
  res.on 'end', ->
    pkginfo = JSON.parse val
    version = pkginfo['dist-tags'].stable ? pkginfo['dist-tags'].latest
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
                               deps = [ #{deps.join " "} ];
                             };
                             """
    deps = (key for key, value of (pkginfo.versions[version].dependencies ? {}))
