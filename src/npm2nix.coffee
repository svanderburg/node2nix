#!/usr/bin/env coffee
http = require 'http'
crypto = require 'crypto'
semver = require 'semver'

generated = {}

generateExpr = (name, range) ->
   generated[name + "-" + range] = true
   http.get "http://registry.npmjs.org/#{name}", (res) ->
    res.setEncoding()
    val = ""
    res.on 'data', (chunk) ->
      val += chunk
    res.on 'end', ->
      pkginfo = JSON.parse val
      versions = (key for own key, value of pkginfo.versions)
      version = semver.maxSatisfying versions, range
      deps = pkginfo.versions[version].dependencies ? {}
      patchLatest = false
      for nm, ver of deps
        if ver == 'latest'
          deps[nm] = '*'
          patchLatest = true
      (generateExpr(nm, ver) unless generated[nm + "-" + ver]?) for nm, ver of deps
      http.get "http://registry.npmjs.org/#{name}/-/#{name}-#{version}.tgz", (res) ->
        hash = crypto.createHash 'sha256'
        res.on 'data', (chunk) ->
          hash.update chunk
        res.on 'end', ->
          console.log """
            #{}  "#{name}" = self."#{name}-#{range}";

              "#{name}-#{range}" = self.buildNodePackage rec {
                name = "#{name}-#{version}";
                src = #{if patchLatest then 'self.patchLatest' else 'fetchurl'} {
                  url = "http://registry.npmjs.org/#{name}/-/${name}.tgz";
                  sha256 = "#{hash.digest('hex')}";
                };
                deps = [
            #{("      self.\"#{dep}#{if ver is "*" then "" else "-#{ver}"}\"" for dep, ver of deps).join "\n"}
                ];
              };

          """

generateExpr process.argv[2], process.argv[3] ? "*"
