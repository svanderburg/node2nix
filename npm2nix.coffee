#!/usr/bin/env coffee
http = require 'http'
crypto = require 'crypto'

generated = {}

generateExpr = (name, version) ->
   generated[name + "-" + version] = true
   http.get "http://registry.npmjs.org/#{name}", (res) ->
    res.setEncoding()
    val = ""
    res.on 'data', (chunk) ->
      val += chunk
    res.on 'end', ->
      pkginfo = JSON.parse val
      version = pkginfo['dist-tags'].stable ? pkginfo['dist-tags'].latest if version is "*"
      deps = pkginfo.versions[version].dependencies ? {}
      (generateExpr(nm, ver) unless generated[nm + "-" + ver]?) for nm, ver of deps
      http.get "http://registry.npmjs.org/#{name}/-/#{name}-#{version}.tgz", (res) ->
        hash = crypto.createHash 'sha256'
        res.on 'data', (chunk) ->
          hash.update chunk
        res.on 'end', ->
          console.log """
            #{}  "#{name}" = self."#{name}-#{version}";

              "#{name}-#{version}" = buildNodePackage rec {
                name = "#{name}-#{version}";
                src = fetchurl {
                  url = "http://registry.npmjs.org/#{name}/-/${name}.tgz";
                  sha256 = "#{hash.digest('hex')}";
                };
                deps = [
            #{("      self.\"#{dep}#{if ver is "*" then "" else "-#{ver}"}\"" for dep, ver of deps).join "\n"}
                ];
              };

          """

generateExpr process.argv[2], process.argv[3] ? "*"
