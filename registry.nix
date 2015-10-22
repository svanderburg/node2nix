{buildNodePackage, fetchurl, fetchgit, self}:

let
  registry = {
    "npm2nix-6.0.0" = buildNodePackage {
      name = "npm2nix";
      version = "6.0.0";
      src = ./.;
      dependencies = {
        optparse = {
          "1.0.x" = {
            version = "1.0.5";
            pkg = self."optparse-1.0.5";
          };
        };
        semver = {
          "5.0.x" = {
            version = "5.0.3";
            pkg = self."semver-5.0.3";
          };
        };
        npm-registry-client = {
          "1.0.x" = {
            version = "1.0.1";
            pkg = self."npm-registry-client-1.0.1";
          };
        };
        npmconf = {
          "2.0.x" = {
            version = "2.0.9";
            pkg = self."npmconf-2.0.9";
          };
        };
        tar = {
          "1.0.x" = {
            version = "1.0.3";
            pkg = self."tar-1.0.3";
          };
        };
        temp = {
          "0.8.x" = {
            version = "0.8.3";
            pkg = self."temp-0.8.3";
          };
        };
        "fs.extra" = {
          "1.2.x" = {
            version = "1.2.1";
            pkg = self."fs.extra-1.2.1";
          };
        };
        findit = {
          "2.0.x" = {
            version = "2.0.0";
            pkg = self."findit-2.0.0";
          };
        };
        slasp = {
          "0.0.4" = {
            version = "0.0.4";
            pkg = self."slasp-0.0.4";
          };
        };
        nijs = {
          "0.0.23" = {
            version = "0.0.23";
            pkg = self."nijs-0.0.23";
          };
        };
      };
      meta = {
        description = "Generate Nix expressions to build NPM packages";
        homepage = https://github.com/NixOS/npm2nix;
      };
      production = true;
      linkDependencies = false;
    };
    "optparse-1.0.5" = buildNodePackage {
      name = "optparse";
      version = "1.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/optparse/-/optparse-1.0.5.tgz";
        sha1 = "75e75a96506611eb1c65ba89018ff08a981e2c16";
      };
      meta = {
        description = "Command-line option parser";
      };
      production = true;
      linkDependencies = false;
    };
    "optparse-1.0.x" = self."optparse-1.0.5";
    "semver-5.0.3" = buildNodePackage {
      name = "semver";
      version = "5.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-5.0.3.tgz";
        sha1 = "77466de589cd5d3c95f138aa78bc569a3cb5d27a";
      };
      meta = {
        description = "The semantic version parser used by npm.";
        homepage = "https://github.com/npm/node-semver#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "semver-5.0.x" = self."semver-5.0.3";
    "npm-registry-client-1.0.1" = buildNodePackage {
      name = "npm-registry-client";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-1.0.1.tgz";
        sha1 = "c5f6a87d285f2005a35d3f67d9c724bce551b0f1";
      };
      dependencies = {
        chownr = {
          "0" = {
            version = "0.0.2";
            pkg = self."chownr-0.0.2";
          };
        };
        graceful-fs = {
          "~2.0.0" = {
            version = "2.0.3";
            pkg = self."graceful-fs-2.0.3";
          };
        };
        mkdirp = {
          "~0.3.3" = {
            version = "0.3.5";
            pkg = self."mkdirp-0.3.5";
          };
        };
        npm-cache-filename = {
          "^1.0.0" = {
            version = "1.0.2";
            pkg = self."npm-cache-filename-1.0.2";
          };
        };
        request = {
          "2 >=2.25.0" = {
            version = "2.65.0";
            pkg = self."request-2.65.0";
          };
        };
        retry = {
          "0.6.0" = {
            version = "0.6.0";
            pkg = self."retry-0.6.0";
          };
        };
        rimraf = {
          "~2" = {
            version = "2.4.3";
            pkg = self."rimraf-2.4.3";
          };
        };
        semver = {
          "2 >=2.2.1" = {
            version = "2.3.2";
            pkg = self."semver-2.3.2";
          };
        };
        slide = {
          "~1.1.3" = {
            version = "1.1.6";
            pkg = self."slide-1.1.6";
          };
        };
        npmlog = {
          "" = {
            version = "1.2.1";
            pkg = self."npmlog-1.2.1";
          };
        };
      };
      meta = {
        description = "Client for the npm registry";
        homepage = https://github.com/isaacs/npm-registry-client;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "chownr-0.0.2" = buildNodePackage {
      name = "chownr";
      version = "0.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/chownr/-/chownr-0.0.2.tgz";
        sha1 = "2f9aebf746f90808ce00607b72ba73b41604c485";
      };
      meta = {
        description = "like `chown -R`";
        homepage = "https://github.com/isaacs/chownr#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    chownr-0 = self."chownr-0.0.2";
    "graceful-fs-2.0.3" = buildNodePackage {
      name = "graceful-fs";
      version = "2.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.3.tgz";
        sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
      };
      meta = {
        description = "A drop-in replacement for fs, making various improvements.";
        homepage = https://github.com/isaacs/node-graceful-fs;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-fs-~2.0.0" = self."graceful-fs-2.0.3";
    "mkdirp-0.3.5" = buildNodePackage {
      name = "mkdirp";
      version = "0.3.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      };
      meta = {
        description = "Recursively mkdir, like `mkdir -p`";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mkdirp-~0.3.3" = self."mkdirp-0.3.5";
    "npm-cache-filename-1.0.2" = buildNodePackage {
      name = "npm-cache-filename";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/npm-cache-filename/-/npm-cache-filename-1.0.2.tgz";
        sha1 = "ded306c5b0bfc870a9e9faf823bc5f283e05ae11";
      };
      dependencies = {};
      meta = {
        description = "Given a cache folder and url, return the appropriate cache folder.";
        homepage = https://github.com/npm/npm-cache-filename;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "npm-cache-filename-^1.0.0" = self."npm-cache-filename-1.0.2";
    "request-2.65.0" = buildNodePackage {
      name = "request";
      version = "2.65.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.65.0.tgz";
        sha1 = "cc1a3bc72b96254734fc34296da322f9486ddeba";
      };
      dependencies = {
        bl = {
          "~1.0.0" = {
            version = "1.0.0";
            pkg = self."bl-1.0.0";
          };
        };
        caseless = {
          "~0.11.0" = {
            version = "0.11.0";
            pkg = self."caseless-0.11.0";
          };
        };
        extend = {
          "~3.0.0" = {
            version = "3.0.0";
            pkg = self."extend-3.0.0";
          };
        };
        forever-agent = {
          "~0.6.1" = {
            version = "0.6.1";
            pkg = self."forever-agent-0.6.1";
          };
        };
        form-data = {
          "~1.0.0-rc3" = {
            version = "1.0.0-rc3";
            pkg = self."form-data-1.0.0-rc3";
          };
        };
        json-stringify-safe = {
          "~5.0.1" = {
            version = "5.0.1";
            pkg = self."json-stringify-safe-5.0.1";
          };
        };
        mime-types = {
          "~2.1.7" = {
            version = "2.1.7";
            pkg = self."mime-types-2.1.7";
          };
        };
        node-uuid = {
          "~1.4.3" = {
            version = "1.4.3";
            pkg = self."node-uuid-1.4.3";
          };
        };
        qs = {
          "~5.2.0" = {
            version = "5.2.0";
            pkg = self."qs-5.2.0";
          };
        };
        tunnel-agent = {
          "~0.4.1" = {
            version = "0.4.1";
            pkg = self."tunnel-agent-0.4.1";
          };
        };
        tough-cookie = {
          "~2.2.0" = {
            version = "2.2.0";
            pkg = self."tough-cookie-2.2.0";
          };
        };
        http-signature = {
          "~0.11.0" = {
            version = "0.11.0";
            pkg = self."http-signature-0.11.0";
          };
        };
        oauth-sign = {
          "~0.8.0" = {
            version = "0.8.0";
            pkg = self."oauth-sign-0.8.0";
          };
        };
        hawk = {
          "~3.1.0" = {
            version = "3.1.0";
            pkg = self."hawk-3.1.0";
          };
        };
        aws-sign2 = {
          "~0.6.0" = {
            version = "0.6.0";
            pkg = self."aws-sign2-0.6.0";
          };
        };
        stringstream = {
          "~0.0.4" = {
            version = "0.0.4";
            pkg = self."stringstream-0.0.4";
          };
        };
        combined-stream = {
          "~1.0.5" = {
            version = "1.0.5";
            pkg = self."combined-stream-1.0.5";
          };
        };
        isstream = {
          "~0.1.2" = {
            version = "0.1.2";
            pkg = self."isstream-0.1.2";
          };
        };
        har-validator = {
          "~2.0.2" = {
            version = "2.0.2";
            pkg = self."har-validator-2.0.2";
          };
        };
      };
      meta = {
        description = "Simplified HTTP request client.";
        homepage = "https://github.com/request/request#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "bl-1.0.0" = buildNodePackage {
      name = "bl";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/bl/-/bl-1.0.0.tgz";
        sha1 = "ada9a8a89a6d7ac60862f7dec7db207873e0c3f5";
      };
      dependencies = {
        readable-stream = {
          "~2.0.0" = {
            version = "2.0.2";
            pkg = self."readable-stream-2.0.2";
          };
        };
      };
      meta = {
        description = "Buffer List: collect buffers and access with a standard readable Buffer interface, streamable too!";
        homepage = https://github.com/rvagg/bl;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "readable-stream-2.0.2" = buildNodePackage {
      name = "readable-stream";
      version = "2.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-2.0.2.tgz";
        sha1 = "bec81beae8cf455168bc2e5b2b31f5bcfaed9b1b";
      };
      dependencies = {
        core-util-is = {
          "~1.0.0" = {
            version = "1.0.1";
            pkg = self."core-util-is-1.0.1";
          };
        };
        inherits = {
          "~2.0.1" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
        isarray = {
          "0.0.1" = {
            version = "0.0.1";
            pkg = self."isarray-0.0.1";
          };
        };
        process-nextick-args = {
          "~1.0.0" = {
            version = "1.0.3";
            pkg = self."process-nextick-args-1.0.3";
          };
        };
        string_decoder = {
          "~0.10.x" = {
            version = "0.10.31";
            pkg = self."string_decoder-0.10.31";
          };
        };
        util-deprecate = {
          "~1.0.1" = {
            version = "1.0.2";
            pkg = self."util-deprecate-1.0.2";
          };
        };
      };
      meta = {
        description = "Streams3, a user-land copy of the stream library from iojs v2.x";
        homepage = "https://github.com/nodejs/readable-stream#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "core-util-is-1.0.1" = buildNodePackage {
      name = "core-util-is";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
        sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
      };
      meta = {
        description = "The `util.is*` functions introduced in Node v0.12.";
        homepage = https://github.com/isaacs/core-util-is;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "core-util-is-~1.0.0" = self."core-util-is-1.0.1";
    "inherits-2.0.1" = buildNodePackage {
      name = "inherits";
      version = "2.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      };
      meta = {
        description = "Browser-friendly inheritance fully compatible with standard node.js inherits()";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "inherits-~2.0.1" = self."inherits-2.0.1";
    "isarray-0.0.1" = buildNodePackage {
      name = "isarray";
      version = "0.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      };
      dependencies = {};
      meta = {
        description = "Array#isArray for older browsers";
        homepage = https://github.com/juliangruber/isarray;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "process-nextick-args-1.0.3" = buildNodePackage {
      name = "process-nextick-args";
      version = "1.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.3.tgz";
        sha1 = "e272eed825d5e9f4ea74d8d73b1fe311c3beb630";
      };
      meta = {
        description = "process.nextTick but always with args";
        homepage = https://github.com/calvinmetcalf/process-nextick-args;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "process-nextick-args-~1.0.0" = self."process-nextick-args-1.0.3";
    "string_decoder-0.10.31" = buildNodePackage {
      name = "string_decoder";
      version = "0.10.31";
      src = fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
      dependencies = {};
      meta = {
        description = "The string_decoder module from Node core";
        homepage = https://github.com/rvagg/string_decoder;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "string_decoder-~0.10.x" = self."string_decoder-0.10.31";
    "util-deprecate-1.0.2" = buildNodePackage {
      name = "util-deprecate";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
      meta = {
        description = "The Node.js `util.deprecate()` function with browser support";
        homepage = https://github.com/TooTallNate/util-deprecate;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "util-deprecate-~1.0.1" = self."util-deprecate-1.0.2";
    "readable-stream-~2.0.0" = self."readable-stream-2.0.2";
    "bl-~1.0.0" = self."bl-1.0.0";
    "caseless-0.11.0" = buildNodePackage {
      name = "caseless";
      version = "0.11.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
        sha1 = "715b96ea9841593cc33067923f5ec60ebda4f7d7";
      };
      meta = {
        description = "Caseless object set/get/has, very useful when working with HTTP headers.";
        homepage = "https://github.com/mikeal/caseless#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "caseless-~0.11.0" = self."caseless-0.11.0";
    "extend-3.0.0" = buildNodePackage {
      name = "extend";
      version = "3.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
        sha1 = "5a474353b9f3353ddd8176dfd37b91c83a46f1d4";
      };
      dependencies = {};
      meta = {
        description = "Port of jQuery.extend for node.js and the browser";
        homepage = "https://github.com/justmoon/node-extend#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "extend-~3.0.0" = self."extend-3.0.0";
    "forever-agent-0.6.1" = buildNodePackage {
      name = "forever-agent";
      version = "0.6.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
      dependencies = {};
      meta = {
        description = "HTTP Agent that keeps socket connections alive between keep-alive requests. Formerly part of mikeal/request, now a standalone module.";
        homepage = https://github.com/mikeal/forever-agent;
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "forever-agent-~0.6.1" = self."forever-agent-0.6.1";
    "form-data-1.0.0-rc3" = buildNodePackage {
      name = "form-data";
      version = "1.0.0-rc3";
      src = fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc3.tgz";
        sha1 = "d35bc62e7fbc2937ae78f948aaa0d38d90607577";
      };
      dependencies = {
        async = {
          "^1.4.0" = {
            version = "1.4.2";
            pkg = self."async-1.4.2";
          };
        };
        combined-stream = {
          "^1.0.5" = {
            version = "1.0.5";
            pkg = self."combined-stream-1.0.5";
          };
        };
        mime-types = {
          "^2.1.3" = {
            version = "2.1.7";
            pkg = self."mime-types-2.1.7";
          };
        };
      };
      meta = {
        description = "A library to create readable \"multipart/form-data\" streams. Can be used to submit forms and file uploads to other web applications.";
        homepage = "https://github.com/form-data/form-data#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "async-1.4.2" = buildNodePackage {
      name = "async";
      version = "1.4.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/async/-/async-1.4.2.tgz";
        sha1 = "6c9edcb11ced4f0dd2f2d40db0d49a109c088aab";
      };
      meta = {
        description = "Higher-order functions and common patterns for asynchronous code";
        homepage = "https://github.com/caolan/async#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "async-^1.4.0" = self."async-1.4.2";
    "combined-stream-1.0.5" = buildNodePackage {
      name = "combined-stream";
      version = "1.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
        sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
      };
      dependencies = {
        delayed-stream = {
          "~1.0.0" = {
            version = "1.0.0";
            pkg = self."delayed-stream-1.0.0";
          };
        };
      };
      meta = {
        description = "A stream that emits multiple other streams one after another.";
        homepage = https://github.com/felixge/node-combined-stream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "delayed-stream-1.0.0" = buildNodePackage {
      name = "delayed-stream";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
      dependencies = {};
      meta = {
        description = "Buffers events from a stream until you are ready to handle them.";
        homepage = https://github.com/felixge/node-delayed-stream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "delayed-stream-~1.0.0" = self."delayed-stream-1.0.0";
    "combined-stream-^1.0.5" = self."combined-stream-1.0.5";
    "mime-types-2.1.7" = buildNodePackage {
      name = "mime-types";
      version = "2.1.7";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.7.tgz";
        sha1 = "ff603970e3c731ef6f7f4df3c9a0f463a13c2755";
      };
      dependencies = {
        mime-db = {
          "~1.19.0" = {
            version = "1.19.0";
            pkg = self."mime-db-1.19.0";
          };
        };
      };
      meta = {
        description = "The ultimate javascript content-type utility.";
        homepage = https://github.com/jshttp/mime-types;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mime-db-1.19.0" = buildNodePackage {
      name = "mime-db";
      version = "1.19.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.19.0.tgz";
        sha1 = "496a18198a7ce8244534e25bb102b74fb420fd56";
      };
      meta = {
        description = "Media Type Database";
        homepage = https://github.com/jshttp/mime-db;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mime-db-~1.19.0" = self."mime-db-1.19.0";
    "mime-types-^2.1.3" = self."mime-types-2.1.7";
    "form-data-~1.0.0-rc3" = self."form-data-1.0.0-rc3";
    "json-stringify-safe-5.0.1" = buildNodePackage {
      name = "json-stringify-safe";
      version = "5.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
      meta = {
        description = "Like JSON.stringify, but doesn't blow up on circular refs.";
        homepage = https://github.com/isaacs/json-stringify-safe;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "json-stringify-safe-~5.0.1" = self."json-stringify-safe-5.0.1";
    "mime-types-~2.1.7" = self."mime-types-2.1.7";
    "node-uuid-1.4.3" = buildNodePackage {
      name = "node-uuid";
      version = "1.4.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.3.tgz";
        sha1 = "319bb7a56e7cb63f00b5c0cd7851cd4b4ddf1df9";
      };
      meta = {
        description = "Rigorous implementation of RFC4122 (v1 and v4) UUIDs.";
        homepage = https://github.com/broofa/node-uuid;
      };
      production = true;
      linkDependencies = false;
    };
    "node-uuid-~1.4.3" = self."node-uuid-1.4.3";
    "qs-5.2.0" = buildNodePackage {
      name = "qs";
      version = "5.2.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-5.2.0.tgz";
        sha1 = "a9f31142af468cb72b25b30136ba2456834916be";
      };
      dependencies = {};
      meta = {
        description = "A querystring parser that supports nesting and arrays, with a depth limit";
        homepage = https://github.com/hapijs/qs;
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "qs-~5.2.0" = self."qs-5.2.0";
    "tunnel-agent-0.4.1" = buildNodePackage {
      name = "tunnel-agent";
      version = "0.4.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.1.tgz";
        sha1 = "bbeecff4d679ce753db9462761a88dfcec3c5ab3";
      };
      dependencies = {};
      meta = {
        description = "HTTP proxy tunneling agent. Formerly part of mikeal/request, now a standalone module.";
        homepage = "https://github.com/mikeal/tunnel-agent#readme";
      };
      production = true;
      linkDependencies = false;
    };
    "tunnel-agent-~0.4.1" = self."tunnel-agent-0.4.1";
    "tough-cookie-2.2.0" = buildNodePackage {
      name = "tough-cookie";
      version = "2.2.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-2.2.0.tgz";
        sha1 = "d4ce661075e5fddb7f20341d3f9931a6fbbadde0";
      };
      meta = {
        description = "RFC6265 Cookies and Cookie Jar for node.js";
        homepage = https://github.com/SalesforceEng/tough-cookie;
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "tough-cookie-~2.2.0" = self."tough-cookie-2.2.0";
    "http-signature-0.11.0" = buildNodePackage {
      name = "http-signature";
      version = "0.11.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.11.0.tgz";
        sha1 = "1796cf67a001ad5cd6849dca0991485f09089fe6";
      };
      dependencies = {
        assert-plus = {
          "^0.1.5" = {
            version = "0.1.5";
            pkg = self."assert-plus-0.1.5";
          };
        };
        asn1 = {
          "0.1.11" = {
            version = "0.1.11";
            pkg = self."asn1-0.1.11";
          };
        };
        ctype = {
          "0.5.3" = {
            version = "0.5.3";
            pkg = self."ctype-0.5.3";
          };
        };
      };
      meta = {
        description = "Reference implementation of Joyent's HTTP Signature scheme.";
        homepage = https://github.com/joyent/node-http-signature/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "assert-plus-0.1.5" = buildNodePackage {
      name = "assert-plus";
      version = "0.1.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
        sha1 = "ee74009413002d84cec7219c6ac811812e723160";
      };
      dependencies = {};
      meta = {
        description = "Extra assertions on top of node's assert module";
      };
      production = true;
      linkDependencies = false;
    };
    "assert-plus-^0.1.5" = self."assert-plus-0.1.5";
    "asn1-0.1.11" = buildNodePackage {
      name = "asn1";
      version = "0.1.11";
      src = fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      };
      dependencies = {};
      meta = {
        description = "Contains parsers and serializers for ASN.1 (currently BER only)";
      };
      production = true;
      linkDependencies = false;
    };
    "ctype-0.5.3" = buildNodePackage {
      name = "ctype";
      version = "0.5.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
        sha1 = "82c18c2461f74114ef16c135224ad0b9144ca12f";
      };
      meta = {
        description = "read and write binary structures and data types";
        homepage = https://github.com/rmustacc/node-ctype;
      };
      production = true;
      linkDependencies = false;
    };
    "http-signature-~0.11.0" = self."http-signature-0.11.0";
    "oauth-sign-0.8.0" = buildNodePackage {
      name = "oauth-sign";
      version = "0.8.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.0.tgz";
        sha1 = "938fdc875765ba527137d8aec9d178e24debc553";
      };
      dependencies = {};
      meta = {
        description = "OAuth 1 signing. Formerly a vendor lib in mikeal/request, now a standalone module.";
        homepage = "https://github.com/mikeal/oauth-sign#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "oauth-sign-~0.8.0" = self."oauth-sign-0.8.0";
    "hawk-3.1.0" = buildNodePackage {
      name = "hawk";
      version = "3.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-3.1.0.tgz";
        sha1 = "8a13ae19977ec607602f3f0b9fd676f18c384e44";
      };
      dependencies = {
        hoek = {
          "2.x.x" = {
            version = "2.16.3";
            pkg = self."hoek-2.16.3";
          };
        };
        boom = {
          "^2.8.x" = {
            version = "2.9.0";
            pkg = self."boom-2.9.0";
          };
        };
        cryptiles = {
          "2.x.x" = {
            version = "2.0.5";
            pkg = self."cryptiles-2.0.5";
          };
        };
        sntp = {
          "1.x.x" = {
            version = "1.0.9";
            pkg = self."sntp-1.0.9";
          };
        };
      };
      meta = {
        description = "HTTP Hawk Authentication Scheme";
        homepage = "https://github.com/hueniverse/hawk#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "hoek-2.16.3" = buildNodePackage {
      name = "hoek";
      version = "2.16.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
        sha1 = "20bb7403d3cea398e91dc4710a8ff1b8274a25ed";
      };
      dependencies = {};
      meta = {
        description = "General purpose node utilities";
        homepage = "https://github.com/hapijs/hoek#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "hoek-2.x.x" = self."hoek-2.16.3";
    "boom-2.9.0" = buildNodePackage {
      name = "boom";
      version = "2.9.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-2.9.0.tgz";
        sha1 = "a54b7fd2fee477d351bf9e371680cbea67f12715";
      };
      dependencies = {
        hoek = {
          "2.x.x" = {
            version = "2.16.3";
            pkg = self."hoek-2.16.3";
          };
        };
      };
      meta = {
        description = "HTTP-friendly error objects";
        homepage = "https://github.com/hapijs/boom#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "boom-^2.8.x" = self."boom-2.9.0";
    "cryptiles-2.0.5" = buildNodePackage {
      name = "cryptiles";
      version = "2.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
        sha1 = "3bdfecdc608147c1c67202fa291e7dca59eaa3b8";
      };
      dependencies = {
        boom = {
          "2.x.x" = {
            version = "2.9.0";
            pkg = self."boom-2.9.0";
          };
        };
      };
      meta = {
        description = "General purpose crypto utilities";
        homepage = "https://github.com/hapijs/cryptiles#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "boom-2.x.x" = self."boom-2.9.0";
    "cryptiles-2.x.x" = self."cryptiles-2.0.5";
    "sntp-1.0.9" = buildNodePackage {
      name = "sntp";
      version = "1.0.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
        sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
      };
      dependencies = {
        hoek = {
          "2.x.x" = {
            version = "2.16.3";
            pkg = self."hoek-2.16.3";
          };
        };
      };
      meta = {
        description = "SNTP Client";
        homepage = https://github.com/hueniverse/sntp;
      };
      production = true;
      linkDependencies = false;
    };
    "sntp-1.x.x" = self."sntp-1.0.9";
    "hawk-~3.1.0" = self."hawk-3.1.0";
    "aws-sign2-0.6.0" = buildNodePackage {
      name = "aws-sign2";
      version = "0.6.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz";
        sha1 = "14342dd38dbcc94d0e5b87d763cd63612c0e794f";
      };
      dependencies = {};
      meta = {
        description = "AWS signing. Originally pulled from LearnBoost/knox, maintained as vendor in request, now a standalone module.";
        homepage = "https://github.com/mikeal/aws-sign#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "aws-sign2-~0.6.0" = self."aws-sign2-0.6.0";
    "stringstream-0.0.4" = buildNodePackage {
      name = "stringstream";
      version = "0.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.4.tgz";
        sha1 = "0f0e3423f942960b5692ac324a57dd093bc41a92";
      };
      meta = {
        description = "Encode and decode streams into string streams";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "stringstream-~0.0.4" = self."stringstream-0.0.4";
    "combined-stream-~1.0.5" = self."combined-stream-1.0.5";
    "isstream-0.1.2" = buildNodePackage {
      name = "isstream";
      version = "0.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
      meta = {
        description = "Determine if an object is a Stream";
        homepage = https://github.com/rvagg/isstream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "isstream-~0.1.2" = self."isstream-0.1.2";
    "har-validator-2.0.2" = buildNodePackage {
      name = "har-validator";
      version = "2.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/har-validator/-/har-validator-2.0.2.tgz";
        sha1 = "233d0fa887b98a4f345969f811a2eec70d97aed7";
      };
      dependencies = {
        chalk = {
          "^1.1.1" = {
            version = "1.1.1";
            pkg = self."chalk-1.1.1";
          };
        };
        commander = {
          "^2.8.1" = {
            version = "2.9.0";
            pkg = self."commander-2.9.0";
          };
        };
        is-my-json-valid = {
          "^2.12.2" = {
            version = "2.12.2";
            pkg = self."is-my-json-valid-2.12.2";
          };
        };
        pinkie-promise = {
          "^1.0.0" = {
            version = "1.0.0";
            pkg = self."pinkie-promise-1.0.0";
          };
        };
      };
      meta = {
        description = "Extremely fast HTTP Archive (HAR) validator using JSON Schema";
        homepage = https://github.com/ahmadnassri/har-validator;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "chalk-1.1.1" = buildNodePackage {
      name = "chalk";
      version = "1.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-1.1.1.tgz";
        sha1 = "509afb67066e7499f7eb3535c77445772ae2d019";
      };
      dependencies = {
        ansi-styles = {
          "^2.1.0" = {
            version = "2.1.0";
            pkg = self."ansi-styles-2.1.0";
          };
        };
        escape-string-regexp = {
          "^1.0.2" = {
            version = "1.0.3";
            pkg = self."escape-string-regexp-1.0.3";
          };
        };
        has-ansi = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."has-ansi-2.0.0";
          };
        };
        strip-ansi = {
          "^3.0.0" = {
            version = "3.0.0";
            pkg = self."strip-ansi-3.0.0";
          };
        };
        supports-color = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."supports-color-2.0.0";
          };
        };
      };
      meta = {
        description = "Terminal string styling done right. Much color.";
        homepage = "https://github.com/chalk/chalk#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-styles-2.1.0" = buildNodePackage {
      name = "ansi-styles";
      version = "2.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.1.0.tgz";
        sha1 = "990f747146927b559a932bf92959163d60c0d0e2";
      };
      meta = {
        description = "ANSI escape codes for styling strings in the terminal";
        homepage = https://github.com/chalk/ansi-styles;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-styles-^2.1.0" = self."ansi-styles-2.1.0";
    "escape-string-regexp-1.0.3" = buildNodePackage {
      name = "escape-string-regexp";
      version = "1.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.3.tgz";
        sha1 = "9e2d8b25bc2555c3336723750e03f099c2735bb5";
      };
      meta = {
        description = "Escape RegExp special characters";
        homepage = https://github.com/sindresorhus/escape-string-regexp;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "escape-string-regexp-^1.0.2" = self."escape-string-regexp-1.0.3";
    "has-ansi-2.0.0" = buildNodePackage {
      name = "has-ansi";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
      dependencies = {
        ansi-regex = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."ansi-regex-2.0.0";
          };
        };
      };
      meta = {
        description = "Check if a string has ANSI escape codes";
        homepage = https://github.com/sindresorhus/has-ansi;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-regex-2.0.0" = buildNodePackage {
      name = "ansi-regex";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
        sha1 = "c5061b6e0ef8a81775e50f5d66151bf6bf371107";
      };
      meta = {
        description = "Regular expression for matching ANSI escape codes";
        homepage = https://github.com/sindresorhus/ansi-regex;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-regex-^2.0.0" = self."ansi-regex-2.0.0";
    "has-ansi-^2.0.0" = self."has-ansi-2.0.0";
    "strip-ansi-3.0.0" = buildNodePackage {
      name = "strip-ansi";
      version = "3.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.0.tgz";
        sha1 = "7510b665567ca914ccb5d7e072763ac968be3724";
      };
      dependencies = {
        ansi-regex = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."ansi-regex-2.0.0";
          };
        };
      };
      meta = {
        description = "Strip ANSI escape codes";
        homepage = https://github.com/sindresorhus/strip-ansi;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "strip-ansi-^3.0.0" = self."strip-ansi-3.0.0";
    "supports-color-2.0.0" = buildNodePackage {
      name = "supports-color";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
      meta = {
        description = "Detect whether a terminal supports color";
        homepage = https://github.com/chalk/supports-color;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "supports-color-^2.0.0" = self."supports-color-2.0.0";
    "chalk-^1.1.1" = self."chalk-1.1.1";
    "commander-2.9.0" = buildNodePackage {
      name = "commander";
      version = "2.9.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
        sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
      };
      dependencies = {
        graceful-readlink = {
          ">= 1.0.0" = {
            version = "1.0.1";
            pkg = self."graceful-readlink-1.0.1";
          };
        };
      };
      meta = {
        description = "the complete solution for node.js command-line programs";
        homepage = "https://github.com/tj/commander.js#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-readlink-1.0.1" = buildNodePackage {
      name = "graceful-readlink";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
      meta = {
        description = "graceful fs.readlink";
        homepage = https://github.com/zhiyelee/graceful-readlink;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-readlink->= 1.0.0" = self."graceful-readlink-1.0.1";
    "commander-^2.8.1" = self."commander-2.9.0";
    "is-my-json-valid-2.12.2" = buildNodePackage {
      name = "is-my-json-valid";
      version = "2.12.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.12.2.tgz";
        sha1 = "0d65859318c846ce3a134402fd3fbc504272ccc9";
      };
      dependencies = {
        generate-function = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."generate-function-2.0.0";
          };
        };
        generate-object-property = {
          "^1.1.0" = {
            version = "1.2.0";
            pkg = self."generate-object-property-1.2.0";
          };
        };
        jsonpointer = {
          "2.0.0" = {
            version = "2.0.0";
            pkg = self."jsonpointer-2.0.0";
          };
        };
        xtend = {
          "^4.0.0" = {
            version = "4.0.0";
            pkg = self."xtend-4.0.0";
          };
        };
      };
      meta = {
        description = "A JSONSchema validator that uses code generation to be extremely fast";
        homepage = https://github.com/mafintosh/is-my-json-valid;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "generate-function-2.0.0" = buildNodePackage {
      name = "generate-function";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
        sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
      };
      meta = {
        description = "Module that helps you write generated functions in Node";
        homepage = https://github.com/mafintosh/generate-function;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "generate-function-^2.0.0" = self."generate-function-2.0.0";
    "generate-object-property-1.2.0" = buildNodePackage {
      name = "generate-object-property";
      version = "1.2.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
        sha1 = "9c0e1c40308ce804f4783618b937fa88f99d50d0";
      };
      dependencies = {
        is-property = {
          "^1.0.0" = {
            version = "1.0.2";
            pkg = self."is-property-1.0.2";
          };
        };
      };
      meta = {
        description = "Generate safe JS code that can used to reference a object property";
        homepage = https://github.com/mafintosh/generate-object-property;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "is-property-1.0.2" = buildNodePackage {
      name = "is-property";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
        sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
      };
      dependencies = {};
      meta = {
        description = "Tests if a JSON property can be accessed using . syntax";
        homepage = https://github.com/mikolalysenko/is-property;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "is-property-^1.0.0" = self."is-property-1.0.2";
    "generate-object-property-^1.1.0" = self."generate-object-property-1.2.0";
    "jsonpointer-2.0.0" = buildNodePackage {
      name = "jsonpointer";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-2.0.0.tgz";
        sha1 = "3af1dd20fe85463910d469a385e33017d2a030d9";
      };
      meta = {
        description = "Simple JSON Addressing.";
        homepage = "https://github.com/janl/node-jsonpointer#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "xtend-4.0.0" = buildNodePackage {
      name = "xtend";
      version = "4.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-4.0.0.tgz";
        sha1 = "8bc36ff87aedbe7ce9eaf0bca36b2354a743840f";
      };
      dependencies = {};
      meta = {
        description = "extend like a boss";
        homepage = https://github.com/Raynos/xtend;
      };
      production = true;
      linkDependencies = false;
    };
    "xtend-^4.0.0" = self."xtend-4.0.0";
    "is-my-json-valid-^2.12.2" = self."is-my-json-valid-2.12.2";
    "pinkie-promise-1.0.0" = buildNodePackage {
      name = "pinkie-promise";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/pinkie-promise/-/pinkie-promise-1.0.0.tgz";
        sha1 = "d1da67f5482563bb7cf57f286ae2822ecfbf3670";
      };
      dependencies = {
        pinkie = {
          "^1.0.0" = {
            version = "1.0.0";
            pkg = self."pinkie-1.0.0";
          };
        };
      };
      meta = {
        description = "ES6 Promise ponyfill";
        homepage = "https://github.com/floatdrop/pinkie-promise#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "pinkie-1.0.0" = buildNodePackage {
      name = "pinkie";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/pinkie/-/pinkie-1.0.0.tgz";
        sha1 = "5a47f28ba1015d0201bda7bf0f358e47bec8c7e4";
      };
      dependencies = {};
      meta = {
        description = "Itty bitty little wittle twinkie pinkie ES6 Promise implementation";
        homepage = "https://github.com/floatdrop/pinkie#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "pinkie-^1.0.0" = self."pinkie-1.0.0";
    "pinkie-promise-^1.0.0" = self."pinkie-promise-1.0.0";
    "har-validator-~2.0.2" = self."har-validator-2.0.2";
    "request-2 >=2.25.0" = self."request-2.65.0";
    "retry-0.6.0" = buildNodePackage {
      name = "retry";
      version = "0.6.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/retry/-/retry-0.6.0.tgz";
        sha1 = "1c010713279a6fd1e8def28af0c3ff1871caa537";
      };
      dependencies = {};
      meta = {
        description = "Abstraction for exponential and custom retry strategies for failed operations.";
        homepage = https://github.com/tim-kos/node-retry;
      };
      production = true;
      linkDependencies = false;
    };
    "rimraf-2.4.3" = buildNodePackage {
      name = "rimraf";
      version = "2.4.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.4.3.tgz";
        sha1 = "e5b51c9437a4c582adb955e9f28cf8d945e272af";
      };
      dependencies = {
        glob = {
          "^5.0.14" = {
            version = "5.0.15";
            pkg = self."glob-5.0.15";
          };
        };
      };
      meta = {
        description = "A deep deletion module for node (like `rm -rf`)";
        homepage = "https://github.com/isaacs/rimraf#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "glob-5.0.15" = buildNodePackage {
      name = "glob";
      version = "5.0.15";
      src = fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-5.0.15.tgz";
        sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
      };
      dependencies = {
        inflight = {
          "^1.0.4" = {
            version = "1.0.4";
            pkg = self."inflight-1.0.4";
          };
        };
        inherits = {
          "2" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
        minimatch = {
          "2 || 3" = {
            version = "3.0.0";
            pkg = self."minimatch-3.0.0";
          };
        };
        once = {
          "^1.3.0" = {
            version = "1.3.2";
            pkg = self."once-1.3.2";
          };
        };
        path-is-absolute = {
          "^1.0.0" = {
            version = "1.0.0";
            pkg = self."path-is-absolute-1.0.0";
          };
        };
      };
      meta = {
        description = "a little globber";
        homepage = "https://github.com/isaacs/node-glob#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "inflight-1.0.4" = buildNodePackage {
      name = "inflight";
      version = "1.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
        sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
      };
      dependencies = {
        once = {
          "^1.3.0" = {
            version = "1.3.2";
            pkg = self."once-1.3.2";
          };
        };
        wrappy = {
          "1" = {
            version = "1.0.1";
            pkg = self."wrappy-1.0.1";
          };
        };
      };
      meta = {
        description = "Add callbacks to requests in flight to avoid async duplication";
        homepage = https://github.com/isaacs/inflight;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "once-1.3.2" = buildNodePackage {
      name = "once";
      version = "1.3.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.2.tgz";
        sha1 = "d8feeca93b039ec1dcdee7741c92bdac5e28081b";
      };
      dependencies = {
        wrappy = {
          "1" = {
            version = "1.0.1";
            pkg = self."wrappy-1.0.1";
          };
        };
      };
      meta = {
        description = "Run a function exactly one time";
        homepage = "https://github.com/isaacs/once#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "wrappy-1.0.1" = buildNodePackage {
      name = "wrappy";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
        sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
      };
      dependencies = {};
      meta = {
        description = "Callback wrapping utility";
        homepage = https://github.com/npm/wrappy;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    wrappy-1 = self."wrappy-1.0.1";
    "once-^1.3.0" = self."once-1.3.2";
    "inflight-^1.0.4" = self."inflight-1.0.4";
    inherits-2 = self."inherits-2.0.1";
    "minimatch-3.0.0" = buildNodePackage {
      name = "minimatch";
      version = "3.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-3.0.0.tgz";
        sha1 = "5236157a51e4f004c177fb3c527ff7dd78f0ef83";
      };
      dependencies = {
        brace-expansion = {
          "^1.0.0" = {
            version = "1.1.1";
            pkg = self."brace-expansion-1.1.1";
          };
        };
      };
      meta = {
        description = "a glob matcher in javascript";
        homepage = "https://github.com/isaacs/minimatch#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "brace-expansion-1.1.1" = buildNodePackage {
      name = "brace-expansion";
      version = "1.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.1.tgz";
        sha1 = "da5fb78aef4c44c9e4acf525064fb3208ebab045";
      };
      dependencies = {
        balanced-match = {
          "^0.2.0" = {
            version = "0.2.0";
            pkg = self."balanced-match-0.2.0";
          };
        };
        concat-map = {
          "0.0.1" = {
            version = "0.0.1";
            pkg = self."concat-map-0.0.1";
          };
        };
      };
      meta = {
        description = "Brace expansion as known from sh/bash";
        homepage = https://github.com/juliangruber/brace-expansion;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "balanced-match-0.2.0" = buildNodePackage {
      name = "balanced-match";
      version = "0.2.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.2.0.tgz";
        sha1 = "38f6730c03aab6d5edbb52bd934885e756d71674";
      };
      dependencies = {};
      meta = {
        description = "Match balanced character pairs, like \"{\" and \"}\"";
        homepage = https://github.com/juliangruber/balanced-match;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "balanced-match-^0.2.0" = self."balanced-match-0.2.0";
    "concat-map-0.0.1" = buildNodePackage {
      name = "concat-map";
      version = "0.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
      meta = {
        description = "concatenative mapdashery";
        homepage = https://github.com/substack/node-concat-map;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "brace-expansion-^1.0.0" = self."brace-expansion-1.1.1";
    "minimatch-2 || 3" = self."minimatch-3.0.0";
    "path-is-absolute-1.0.0" = buildNodePackage {
      name = "path-is-absolute";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.0.tgz";
        sha1 = "263dada66ab3f2fb10bf7f9d24dd8f3e570ef912";
      };
      meta = {
        description = "Node.js 0.12 path.isAbsolute() ponyfill";
        homepage = https://github.com/sindresorhus/path-is-absolute;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "path-is-absolute-^1.0.0" = self."path-is-absolute-1.0.0";
    "glob-^5.0.14" = self."glob-5.0.15";
    "rimraf-~2" = self."rimraf-2.4.3";
    "semver-2.3.2" = buildNodePackage {
      name = "semver";
      version = "2.3.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.3.2.tgz";
        sha1 = "b9848f25d6cf36333073ec9ef8856d42f1233e52";
      };
      meta = {
        description = "The semantic version parser used by npm.";
        homepage = https://github.com/isaacs/node-semver;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "semver-2 >=2.2.1" = self."semver-2.3.2";
    "slide-1.1.6" = buildNodePackage {
      name = "slide";
      version = "1.1.6";
      src = fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.6.tgz";
        sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
      };
      dependencies = {};
      meta = {
        description = "A flow control lib small enough to fit on in a slide presentation. Derived live at Oak.JS";
        homepage = https://github.com/isaacs/slide-flow-control;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "slide-~1.1.3" = self."slide-1.1.6";
    "npmlog-1.2.1" = buildNodePackage {
      name = "npmlog";
      version = "1.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-1.2.1.tgz";
        sha1 = "28e7be619609b53f7ad1dd300a10d64d716268b6";
      };
      dependencies = {
        ansi = {
          "~0.3.0" = {
            version = "0.3.0";
            pkg = self."ansi-0.3.0";
          };
        };
        are-we-there-yet = {
          "~1.0.0" = {
            version = "1.0.4";
            pkg = self."are-we-there-yet-1.0.4";
          };
        };
        gauge = {
          "~1.2.0" = {
            version = "1.2.2";
            pkg = self."gauge-1.2.2";
          };
        };
      };
      meta = {
        description = "logger for npm";
        homepage = "https://github.com/isaacs/npmlog#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-0.3.0" = buildNodePackage {
      name = "ansi";
      version = "0.3.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.3.0.tgz";
        sha1 = "74b2f1f187c8553c7f95015bcb76009fb43d38e0";
      };
      meta = {
        description = "Advanced ANSI formatting tool for Node.js";
        homepage = https://github.com/TooTallNate/ansi.js;
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-~0.3.0" = self."ansi-0.3.0";
    "are-we-there-yet-1.0.4" = buildNodePackage {
      name = "are-we-there-yet";
      version = "1.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.0.4.tgz";
        sha1 = "527fe389f7bcba90806106b99244eaa07e886f85";
      };
      dependencies = {
        delegates = {
          "^0.1.0" = {
            version = "0.1.0";
            pkg = self."delegates-0.1.0";
          };
        };
        readable-stream = {
          "^1.1.13" = {
            version = "1.1.13";
            pkg = self."readable-stream-1.1.13";
          };
        };
      };
      meta = {
        description = "Keep track of the overall completion of many dispirate processes";
        homepage = https://github.com/iarna/are-we-there-yet;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "delegates-0.1.0" = buildNodePackage {
      name = "delegates";
      version = "0.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/delegates/-/delegates-0.1.0.tgz";
        sha1 = "b4b57be11a1653517a04b27f0949bdc327dfe390";
      };
      dependencies = {};
      meta = {
        description = "delegate methods and accessors to another property";
        homepage = https://github.com/visionmedia/node-delegates;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "delegates-^0.1.0" = self."delegates-0.1.0";
    "readable-stream-1.1.13" = buildNodePackage {
      name = "readable-stream";
      version = "1.1.13";
      src = fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.13.tgz";
        sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
      };
      dependencies = {
        core-util-is = {
          "~1.0.0" = {
            version = "1.0.1";
            pkg = self."core-util-is-1.0.1";
          };
        };
        isarray = {
          "0.0.1" = {
            version = "0.0.1";
            pkg = self."isarray-0.0.1";
          };
        };
        string_decoder = {
          "~0.10.x" = {
            version = "0.10.31";
            pkg = self."string_decoder-0.10.31";
          };
        };
        inherits = {
          "~2.0.1" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
      };
      meta = {
        description = "Streams3, a user-land copy of the stream library from Node.js v0.11.x";
        homepage = https://github.com/isaacs/readable-stream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "readable-stream-^1.1.13" = self."readable-stream-1.1.13";
    "are-we-there-yet-~1.0.0" = self."are-we-there-yet-1.0.4";
    "gauge-1.2.2" = buildNodePackage {
      name = "gauge";
      version = "1.2.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/gauge/-/gauge-1.2.2.tgz";
        sha1 = "05b6730a19a8fcad3c340a142f0945222a3f815b";
      };
      dependencies = {
        ansi = {
          "^0.3.0" = {
            version = "0.3.0";
            pkg = self."ansi-0.3.0";
          };
        };
        has-unicode = {
          "^1.0.0" = {
            version = "1.0.1";
            pkg = self."has-unicode-1.0.1";
          };
        };
        "lodash.pad" = {
          "^3.0.0" = {
            version = "3.1.1";
            pkg = self."lodash.pad-3.1.1";
          };
        };
        "lodash.padleft" = {
          "^3.0.0" = {
            version = "3.1.1";
            pkg = self."lodash.padleft-3.1.1";
          };
        };
        "lodash.padright" = {
          "^3.0.0" = {
            version = "3.1.1";
            pkg = self."lodash.padright-3.1.1";
          };
        };
      };
      meta = {
        description = "A terminal based horizontal guage";
        homepage = https://github.com/iarna/gauge;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-^0.3.0" = self."ansi-0.3.0";
    "has-unicode-1.0.1" = buildNodePackage {
      name = "has-unicode";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/has-unicode/-/has-unicode-1.0.1.tgz";
        sha1 = "c46fceea053eb8ec789bffbba25fca52dfdcf38e";
      };
      meta = {
        description = "Try to guess if your terminal supports unicode";
        homepage = https://github.com/iarna/has-unicode;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "has-unicode-^1.0.0" = self."has-unicode-1.0.1";
    "lodash.pad-3.1.1" = buildNodePackage {
      name = "lodash.pad";
      version = "3.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/lodash.pad/-/lodash.pad-3.1.1.tgz";
        sha1 = "2e078ebc33b331d2ba34bf8732af129fd5c04624";
      };
      dependencies = {
        "lodash._basetostring" = {
          "^3.0.0" = {
            version = "3.0.1";
            pkg = self."lodash._basetostring-3.0.1";
          };
        };
        "lodash._createpadding" = {
          "^3.0.0" = {
            version = "3.6.1";
            pkg = self."lodash._createpadding-3.6.1";
          };
        };
      };
      meta = {
        description = "The modern build of lodash’s `_.pad` as a module.";
        homepage = https://lodash.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "lodash._basetostring-3.0.1" = buildNodePackage {
      name = "lodash._basetostring";
      version = "3.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/lodash._basetostring/-/lodash._basetostring-3.0.1.tgz";
        sha1 = "d1861d877f824a52f669832dcaf3ee15566a07d5";
      };
      meta = {
        description = "The modern build of lodash’s internal `baseToString` as a module.";
        homepage = https://lodash.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "lodash._basetostring-^3.0.0" = self."lodash._basetostring-3.0.1";
    "lodash._createpadding-3.6.1" = buildNodePackage {
      name = "lodash._createpadding";
      version = "3.6.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/lodash._createpadding/-/lodash._createpadding-3.6.1.tgz";
        sha1 = "4907b438595adc54ee8935527a6c424c02c81a87";
      };
      dependencies = {
        "lodash.repeat" = {
          "^3.0.0" = {
            version = "3.0.1";
            pkg = self."lodash.repeat-3.0.1";
          };
        };
      };
      meta = {
        description = "The modern build of lodash’s internal `createPadding` as a module.";
        homepage = https://lodash.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "lodash.repeat-3.0.1" = buildNodePackage {
      name = "lodash.repeat";
      version = "3.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/lodash.repeat/-/lodash.repeat-3.0.1.tgz";
        sha1 = "f4b98dc7ef67256ce61e7874e1865edb208e0edf";
      };
      dependencies = {
        "lodash._basetostring" = {
          "^3.0.0" = {
            version = "3.0.1";
            pkg = self."lodash._basetostring-3.0.1";
          };
        };
      };
      meta = {
        description = "The modern build of lodash’s `_.repeat` as a module.";
        homepage = https://lodash.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "lodash.repeat-^3.0.0" = self."lodash.repeat-3.0.1";
    "lodash._createpadding-^3.0.0" = self."lodash._createpadding-3.6.1";
    "lodash.pad-^3.0.0" = self."lodash.pad-3.1.1";
    "lodash.padleft-3.1.1" = buildNodePackage {
      name = "lodash.padleft";
      version = "3.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/lodash.padleft/-/lodash.padleft-3.1.1.tgz";
        sha1 = "150151f1e0245edba15d50af2d71f1d5cff46530";
      };
      dependencies = {
        "lodash._basetostring" = {
          "^3.0.0" = {
            version = "3.0.1";
            pkg = self."lodash._basetostring-3.0.1";
          };
        };
        "lodash._createpadding" = {
          "^3.0.0" = {
            version = "3.6.1";
            pkg = self."lodash._createpadding-3.6.1";
          };
        };
      };
      meta = {
        description = "The modern build of lodash’s `_.padLeft` as a module.";
        homepage = https://lodash.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "lodash.padleft-^3.0.0" = self."lodash.padleft-3.1.1";
    "lodash.padright-3.1.1" = buildNodePackage {
      name = "lodash.padright";
      version = "3.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/lodash.padright/-/lodash.padright-3.1.1.tgz";
        sha1 = "79f7770baaa39738c040aeb5465e8d88f2aacec0";
      };
      dependencies = {
        "lodash._basetostring" = {
          "^3.0.0" = {
            version = "3.0.1";
            pkg = self."lodash._basetostring-3.0.1";
          };
        };
        "lodash._createpadding" = {
          "^3.0.0" = {
            version = "3.6.1";
            pkg = self."lodash._createpadding-3.6.1";
          };
        };
      };
      meta = {
        description = "The modern build of lodash’s `_.padRight` as a module.";
        homepage = https://lodash.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "lodash.padright-^3.0.0" = self."lodash.padright-3.1.1";
    "gauge-~1.2.0" = self."gauge-1.2.2";
    npmlog = self."npmlog-1.2.1";
    "npm-registry-client-1.0.x" = self."npm-registry-client-1.0.1";
    "npmconf-2.0.9" = buildNodePackage {
      name = "npmconf";
      version = "2.0.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-2.0.9.tgz";
        sha1 = "5c87e5fb308104eceeca781e3d9115d216351ef2";
      };
      dependencies = {
        config-chain = {
          "~1.1.8" = {
            version = "1.1.9";
            pkg = self."config-chain-1.1.9";
          };
        };
        inherits = {
          "~2.0.0" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
        ini = {
          "^1.2.0" = {
            version = "1.3.4";
            pkg = self."ini-1.3.4";
          };
        };
        mkdirp = {
          "^0.5.0" = {
            version = "0.5.0";
            pkg = self."mkdirp-0.5.0";
          };
        };
        nopt = {
          "~3.0.1" = {
            version = "3.0.4";
            pkg = self."nopt-3.0.4";
          };
        };
        once = {
          "~1.3.0" = {
            version = "1.3.2";
            pkg = self."once-1.3.2";
          };
        };
        osenv = {
          "^0.1.0" = {
            version = "0.1.0";
            pkg = self."osenv-0.1.0";
          };
        };
        semver = {
          "2 || 3 || 4" = {
            version = "4.3.6";
            pkg = self."semver-4.3.6";
          };
        };
        uid-number = {
          "0.0.5" = {
            version = "0.0.5";
            pkg = self."uid-number-0.0.5";
          };
        };
      };
      meta = {
        description = "The config thing npm uses";
        homepage = https://github.com/isaacs/npmconf;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "config-chain-1.1.9" = buildNodePackage {
      name = "config-chain";
      version = "1.1.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/config-chain/-/config-chain-1.1.9.tgz";
        sha1 = "39ac7d4dca84faad926124c54cff25a53aa8bf6e";
      };
      dependencies = {
        proto-list = {
          "~1.2.1" = {
            version = "1.2.4";
            pkg = self."proto-list-1.2.4";
          };
        };
        ini = {
          "1" = {
            version = "1.3.4";
            pkg = self."ini-1.3.4";
          };
        };
      };
      meta = {
        description = "HANDLE CONFIGURATION ONCE AND FOR ALL";
        homepage = http://github.com/dominictarr/config-chain;
      };
      production = true;
      linkDependencies = false;
    };
    "proto-list-1.2.4" = buildNodePackage {
      name = "proto-list";
      version = "1.2.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz";
        sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
      };
      meta = {
        description = "A utility for managing a prototype chain";
        homepage = "https://github.com/isaacs/proto-list#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "proto-list-~1.2.1" = self."proto-list-1.2.4";
    "ini-1.3.4" = buildNodePackage {
      name = "ini";
      version = "1.3.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.3.4.tgz";
        sha1 = "0537cb79daf59b59a1a517dff706c86ec039162e";
      };
      dependencies = {};
      meta = {
        description = "An ini encoder/decoder for node";
        homepage = "https://github.com/isaacs/ini#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    ini-1 = self."ini-1.3.4";
    "config-chain-~1.1.8" = self."config-chain-1.1.9";
    "inherits-~2.0.0" = self."inherits-2.0.1";
    "ini-^1.2.0" = self."ini-1.3.4";
    "mkdirp-0.5.0" = buildNodePackage {
      name = "mkdirp";
      version = "0.5.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
        sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
      };
      dependencies = {
        minimist = {
          "0.0.8" = {
            version = "0.0.8";
            pkg = self."minimist-0.0.8";
          };
        };
      };
      meta = {
        description = "Recursively mkdir, like `mkdir -p`";
        homepage = https://github.com/substack/node-mkdirp;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "minimist-0.0.8" = buildNodePackage {
      name = "minimist";
      version = "0.0.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
      meta = {
        description = "parse argument options";
        homepage = https://github.com/substack/minimist;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mkdirp-^0.5.0" = self."mkdirp-0.5.0";
    "nopt-3.0.4" = buildNodePackage {
      name = "nopt";
      version = "3.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-3.0.4.tgz";
        sha1 = "dd63bc9c72a6e4e85b85cdc0ca314598facede5e";
      };
      dependencies = {
        abbrev = {
          "1" = {
            version = "1.0.7";
            pkg = self."abbrev-1.0.7";
          };
        };
      };
      meta = {
        description = "Option parsing for Node, supporting types, shorthands, etc. Used by npm.";
        homepage = "https://github.com/isaacs/nopt#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "abbrev-1.0.7" = buildNodePackage {
      name = "abbrev";
      version = "1.0.7";
      src = fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.7.tgz";
        sha1 = "5b6035b2ee9d4fb5cf859f08a9be81b208491843";
      };
      meta = {
        description = "Like ruby's abbrev module, but in js";
        homepage = "https://github.com/isaacs/abbrev-js#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    abbrev-1 = self."abbrev-1.0.7";
    "nopt-~3.0.1" = self."nopt-3.0.4";
    "once-~1.3.0" = self."once-1.3.2";
    "osenv-0.1.0" = buildNodePackage {
      name = "osenv";
      version = "0.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.1.0.tgz";
        sha1 = "61668121eec584955030b9f470b1d2309504bfcb";
      };
      dependencies = {};
      meta = {
        description = "Look up environment settings specific to different operating systems";
        homepage = https://github.com/isaacs/osenv;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "osenv-^0.1.0" = self."osenv-0.1.0";
    "semver-4.3.6" = buildNodePackage {
      name = "semver";
      version = "4.3.6";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-4.3.6.tgz";
        sha1 = "300bc6e0e86374f7ba61068b5b1ecd57fc6532da";
      };
      meta = {
        description = "The semantic version parser used by npm.";
        homepage = "https://github.com/npm/node-semver#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "semver-2 || 3 || 4" = self."semver-4.3.6";
    "uid-number-0.0.5" = buildNodePackage {
      name = "uid-number";
      version = "0.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.5.tgz";
        sha1 = "5a3db23ef5dbd55b81fce0ec9a2ac6fccdebb81e";
      };
      dependencies = {};
      meta = {
        description = "Convert a username/group name to a uid/gid number";
        homepage = https://github.com/isaacs/uid-number;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "npmconf-2.0.x" = self."npmconf-2.0.9";
    "tar-1.0.3" = buildNodePackage {
      name = "tar";
      version = "1.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-1.0.3.tgz";
        sha1 = "15bcdab244fa4add44e4244a0176edb8aa9a2b44";
      };
      dependencies = {
        block-stream = {
          "*" = {
            version = "0.0.8";
            pkg = self."block-stream-0.0.8";
          };
        };
        fstream = {
          "^1.0.2" = {
            version = "1.0.8";
            pkg = self."fstream-1.0.8";
          };
        };
        inherits = {
          "2" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
      };
      meta = {
        description = "tar for node";
        homepage = https://github.com/isaacs/node-tar;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "block-stream-0.0.8" = buildNodePackage {
      name = "block-stream";
      version = "0.0.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.8.tgz";
        sha1 = "0688f46da2bbf9cff0c4f68225a0cb95cbe8a46b";
      };
      dependencies = {
        inherits = {
          "~2.0.0" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
      };
      meta = {
        description = "a stream of blocks";
        homepage = "https://github.com/isaacs/block-stream#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    block-stream = self."block-stream-0.0.8";
    "fstream-1.0.8" = buildNodePackage {
      name = "fstream";
      version = "1.0.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-1.0.8.tgz";
        sha1 = "7e8d7a73abb3647ef36e4b8a15ca801dba03d038";
      };
      dependencies = {
        graceful-fs = {
          "^4.1.2" = {
            version = "4.1.2";
            pkg = self."graceful-fs-4.1.2";
          };
        };
        inherits = {
          "~2.0.0" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
        mkdirp = {
          ">=0.5 0" = {
            version = "0.5.1";
            pkg = self."mkdirp-0.5.1";
          };
        };
        rimraf = {
          "2" = {
            version = "2.4.3";
            pkg = self."rimraf-2.4.3";
          };
        };
      };
      meta = {
        description = "Advanced file system stream things";
        homepage = "https://github.com/isaacs/fstream#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-fs-4.1.2" = buildNodePackage {
      name = "graceful-fs";
      version = "4.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.2.tgz";
        sha1 = "fe2239b7574972e67e41f808823f9bfa4a991e37";
      };
      meta = {
        description = "A drop-in replacement for fs, making various improvements.";
        homepage = "https://github.com/isaacs/node-graceful-fs#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-fs-^4.1.2" = self."graceful-fs-4.1.2";
    "mkdirp-0.5.1" = buildNodePackage {
      name = "mkdirp";
      version = "0.5.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
      };
      dependencies = {
        minimist = {
          "0.0.8" = {
            version = "0.0.8";
            pkg = self."minimist-0.0.8";
          };
        };
      };
      meta = {
        description = "Recursively mkdir, like `mkdir -p`";
        homepage = "https://github.com/substack/node-mkdirp#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mkdirp->=0.5 0" = self."mkdirp-0.5.1";
    rimraf-2 = self."rimraf-2.4.3";
    "fstream-^1.0.2" = self."fstream-1.0.8";
    "tar-1.0.x" = self."tar-1.0.3";
    "temp-0.8.3" = buildNodePackage {
      name = "temp";
      version = "0.8.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.8.3.tgz";
        sha1 = "e0c6bc4d26b903124410e4fed81103014dfc1f59";
      };
      dependencies = {
        os-tmpdir = {
          "^1.0.0" = {
            version = "1.0.1";
            pkg = self."os-tmpdir-1.0.1";
          };
        };
        rimraf = {
          "~2.2.6" = {
            version = "2.2.8";
            pkg = self."rimraf-2.2.8";
          };
        };
      };
      meta = {
        description = "Temporary files and directories";
        homepage = https://github.com/bruce/node-temp;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "os-tmpdir-1.0.1" = buildNodePackage {
      name = "os-tmpdir";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.1.tgz";
        sha1 = "e9b423a1edaf479882562e92ed71d7743a071b6e";
      };
      meta = {
        description = "Node.js os.tmpdir() ponyfill";
        homepage = https://github.com/sindresorhus/os-tmpdir;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "os-tmpdir-^1.0.0" = self."os-tmpdir-1.0.1";
    "rimraf-2.2.8" = buildNodePackage {
      name = "rimraf";
      version = "2.2.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      };
      meta = {
        description = "A deep deletion module for node (like `rm -rf`)";
        homepage = https://github.com/isaacs/rimraf;
        license = {
          type = "MIT";
          url = "https://github.com/isaacs/rimraf/raw/master/LICENSE";
        };
      };
      production = true;
      linkDependencies = false;
    };
    "rimraf-~2.2.6" = self."rimraf-2.2.8";
    "temp-0.8.x" = self."temp-0.8.3";
    "fs.extra-1.2.1" = buildNodePackage {
      name = "fs.extra";
      version = "1.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/fs.extra/-/fs.extra-1.2.1.tgz";
        sha1 = "060bf20264f35e39ad247e5e9d2121a2a75a1733";
      };
      dependencies = {
        mkdirp = {
          "~0.3.5" = {
            version = "0.3.5";
            pkg = self."mkdirp-0.3.5";
          };
        };
        fs-extra = {
          "~0.6.1" = {
            version = "0.6.4";
            pkg = self."fs-extra-0.6.4";
          };
        };
        walk = {
          "~2.2.1" = {
            version = "2.2.1";
            pkg = self."walk-2.2.1";
          };
        };
      };
      meta = {
        description = "fs.move and fs.copy for Node.JS";
      };
      production = true;
      linkDependencies = false;
    };
    "mkdirp-~0.3.5" = self."mkdirp-0.3.5";
    "fs-extra-0.6.4" = buildNodePackage {
      name = "fs-extra";
      version = "0.6.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.6.4.tgz";
        sha1 = "f46f0c75b7841f8d200b3348cd4d691d5a099d15";
      };
      dependencies = {
        ncp = {
          "~0.4.2" = {
            version = "0.4.2";
            pkg = self."ncp-0.4.2";
          };
        };
        mkdirp = {
          "0.3.x" = {
            version = "0.3.5";
            pkg = self."mkdirp-0.3.5";
          };
        };
        jsonfile = {
          "~1.0.1" = {
            version = "1.0.1";
            pkg = self."jsonfile-1.0.1";
          };
        };
        rimraf = {
          "~2.2.0" = {
            version = "2.2.8";
            pkg = self."rimraf-2.2.8";
          };
        };
      };
      meta = {
        description = "fs-extra contains methods that aren't included in the vanilla Node.js fs package. Such as mkdir -p, cp -r, and rm -rf.";
        homepage = https://github.com/jprichardson/node-fs-extra;
      };
      production = true;
      linkDependencies = false;
    };
    "ncp-0.4.2" = buildNodePackage {
      name = "ncp";
      version = "0.4.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.4.2.tgz";
        sha1 = "abcc6cbd3ec2ed2a729ff6e7c1fa8f01784a8574";
      };
      meta = {
        description = "Asynchronous recursive file copy utility.";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ncp-~0.4.2" = self."ncp-0.4.2";
    "mkdirp-0.3.x" = self."mkdirp-0.3.5";
    "jsonfile-1.0.1" = buildNodePackage {
      name = "jsonfile";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/jsonfile/-/jsonfile-1.0.1.tgz";
        sha1 = "ea5efe40b83690b98667614a7392fc60e842c0dd";
      };
      dependencies = {};
      meta = {
        description = "Easily read/write JSON files.";
      };
      production = true;
      linkDependencies = false;
    };
    "jsonfile-~1.0.1" = self."jsonfile-1.0.1";
    "rimraf-~2.2.0" = self."rimraf-2.2.8";
    "fs-extra-~0.6.1" = self."fs-extra-0.6.4";
    "walk-2.2.1" = buildNodePackage {
      name = "walk";
      version = "2.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.2.1.tgz";
        sha1 = "5ada1f8e49e47d4b7445d8be7a2e1e631ab43016";
      };
      dependencies = {
        forEachAsync = {
          "~2.2" = {
            version = "2.2.1";
            pkg = self."forEachAsync-2.2.1";
          };
        };
      };
      meta = {
        description = "A node port of python's os.walk";
      };
      production = true;
      linkDependencies = false;
    };
    "forEachAsync-2.2.1" = buildNodePackage {
      name = "forEachAsync";
      version = "2.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/forEachAsync/-/forEachAsync-2.2.1.tgz";
        sha1 = "e3723f00903910e1eb4b1db3ad51b5c64a319fec";
      };
      dependencies = {
        sequence = {
          "2.x" = {
            version = "2.2.1";
            pkg = self."sequence-2.2.1";
          };
        };
      };
      meta = {
        description = "The forEachAsync module of FuturesJS (Ender.JS and Node.JS)";
        homepage = https://github.com/coolaj86/futures;
      };
      production = true;
      linkDependencies = false;
    };
    "sequence-2.2.1" = buildNodePackage {
      name = "sequence";
      version = "2.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
        sha1 = "7f5617895d44351c0a047e764467690490a16b03";
      };
      dependencies = {};
      meta = {
        description = "The sequence module of FuturesJS (Ender.JS and Node.JS)";
        homepage = https://github.com/coolaj86/futures;
      };
      production = true;
      linkDependencies = false;
    };
    "sequence-2.x" = self."sequence-2.2.1";
    "forEachAsync-~2.2" = self."forEachAsync-2.2.1";
    "walk-~2.2.1" = self."walk-2.2.1";
    "fs.extra-1.2.x" = self."fs.extra-1.2.1";
    "findit-2.0.0" = buildNodePackage {
      name = "findit";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/findit/-/findit-2.0.0.tgz";
        sha1 = "6509f0126af4c178551cfa99394e032e13a4d56e";
      };
      meta = {
        description = "walk a directory tree recursively with events";
        homepage = https://github.com/substack/node-findit;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "findit-2.0.x" = self."findit-2.0.0";
    "slasp-0.0.4" = buildNodePackage {
      name = "slasp";
      version = "0.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/slasp/-/slasp-0.0.4.tgz";
        sha1 = "9adc26ee729a0f95095851a5489f87a5258d57a9";
      };
      meta = {
        description = "SugarLess Asynchronous Structured Programming library with Object Oriented Programming Support";
        homepage = https://github.com/svanderburg/slasp;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "nijs-0.0.23" = buildNodePackage {
      name = "nijs";
      version = "0.0.23";
      src = fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.23.tgz";
        sha1 = "dbf8f4a0acafbe3b8d9b71c24cbd1d851de6c31a";
      };
      dependencies = {
        optparse = {
          ">= 1.0.3" = {
            version = "1.0.5";
            pkg = self."optparse-1.0.5";
          };
        };
        slasp = {
          "0.0.4" = {
            version = "0.0.4";
            pkg = self."slasp-0.0.4";
          };
        };
      };
      meta = {
        description = "An internal DSL for the Nix package manager in JavaScript";
        homepage = https://github.com/svanderburg/nijs;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "optparse->= 1.0.3" = self."optparse-1.0.5";
  };
in
registry