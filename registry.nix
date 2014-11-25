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
          "3.0.x" = {
            version = "3.0.1";
            pkg = self."semver-3.0.1";
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
            version = "1.0.2";
            pkg = self."tar-1.0.2";
          };
        };
        temp = {
          "0.8.x" = {
            version = "0.8.1";
            pkg = self."temp-0.8.1";
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
          "0.0.22" = {
            version = "0.0.22";
            pkg = self."nijs-0.0.22";
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
    "semver-3.0.1" = buildNodePackage {
      name = "semver";
      version = "3.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-3.0.1.tgz";
        sha1 = "720ac012515a252f91fb0dd2e99a56a70d6cf078";
      };
      meta = {
        description = "The semantic version parser used by npm.";
        homepage = https://github.com/isaacs/node-semver;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "semver-3.0.x" = self."semver-3.0.1";
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
            version = "0.0.1";
            pkg = self."chownr-0.0.1";
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
            version = "1.0.1";
            pkg = self."npm-cache-filename-1.0.1";
          };
        };
        request = {
          "2 >=2.25.0" = {
            version = "2.48.0";
            pkg = self."request-2.48.0";
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
            version = "2.2.8";
            pkg = self."rimraf-2.2.8";
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
            version = "0.1.1";
            pkg = self."npmlog-0.1.1";
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
    "chownr-0.0.1" = buildNodePackage {
      name = "chownr";
      version = "0.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/chownr/-/chownr-0.0.1.tgz";
        sha1 = "51d18189d9092d5f8afd623f3288bfd1c6bf1a62";
      };
      dependencies = {};
      meta = {
        description = "like `chown -R`";
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    chownr-0 = self."chownr-0.0.1";
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
    "npm-cache-filename-1.0.1" = buildNodePackage {
      name = "npm-cache-filename";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/npm-cache-filename/-/npm-cache-filename-1.0.1.tgz";
        sha1 = "9b640f0c1a5ba1145659685372a9ff71f70c4323";
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
    "npm-cache-filename-^1.0.0" = self."npm-cache-filename-1.0.1";
    "request-2.48.0" = buildNodePackage {
      name = "request";
      version = "2.48.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.48.0.tgz";
        sha1 = "3ae2e091c9698282d58a0e6989ece2638f0f1f28";
      };
      dependencies = {
        bl = {
          "~0.9.0" = {
            version = "0.9.3";
            pkg = self."bl-0.9.3";
          };
        };
        caseless = {
          "~0.7.0" = {
            version = "0.7.0";
            pkg = self."caseless-0.7.0";
          };
        };
        forever-agent = {
          "~0.5.0" = {
            version = "0.5.2";
            pkg = self."forever-agent-0.5.2";
          };
        };
        form-data = {
          "~0.1.0" = {
            version = "0.1.4";
            pkg = self."form-data-0.1.4";
          };
        };
        json-stringify-safe = {
          "~5.0.0" = {
            version = "5.0.0";
            pkg = self."json-stringify-safe-5.0.0";
          };
        };
        mime-types = {
          "~1.0.1" = {
            version = "1.0.2";
            pkg = self."mime-types-1.0.2";
          };
        };
        node-uuid = {
          "~1.4.0" = {
            version = "1.4.1";
            pkg = self."node-uuid-1.4.1";
          };
        };
        qs = {
          "~2.3.1" = {
            version = "2.3.3";
            pkg = self."qs-2.3.3";
          };
        };
        tunnel-agent = {
          "~0.4.0" = {
            version = "0.4.0";
            pkg = self."tunnel-agent-0.4.0";
          };
        };
        tough-cookie = {
          ">=0.12.0" = {
            version = "0.12.1";
            pkg = self."tough-cookie-0.12.1";
          };
        };
        http-signature = {
          "~0.10.0" = {
            version = "0.10.0";
            pkg = self."http-signature-0.10.0";
          };
        };
        oauth-sign = {
          "~0.5.0" = {
            version = "0.5.0";
            pkg = self."oauth-sign-0.5.0";
          };
        };
        hawk = {
          "1.1.1" = {
            version = "1.1.1";
            pkg = self."hawk-1.1.1";
          };
        };
        aws-sign2 = {
          "~0.5.0" = {
            version = "0.5.0";
            pkg = self."aws-sign2-0.5.0";
          };
        };
        stringstream = {
          "~0.0.4" = {
            version = "0.0.4";
            pkg = self."stringstream-0.0.4";
          };
        };
        combined-stream = {
          "~0.0.5" = {
            version = "0.0.7";
            pkg = self."combined-stream-0.0.7";
          };
        };
      };
      meta = {
        description = "Simplified HTTP request client.";
        homepage = https://github.com/request/request;
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "bl-0.9.3" = buildNodePackage {
      name = "bl";
      version = "0.9.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/bl/-/bl-0.9.3.tgz";
        sha1 = "c41eff3e7cb31bde107c8f10076d274eff7f7d44";
      };
      dependencies = {
        readable-stream = {
          "~1.0.26" = {
            version = "1.0.33";
            pkg = self."readable-stream-1.0.33";
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
    "readable-stream-1.0.33" = buildNodePackage {
      name = "readable-stream";
      version = "1.0.33";
      src = fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.33.tgz";
        sha1 = "3a360dd66c1b1d7fd4705389860eda1d0f61126c";
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
        description = "Streams2, a user-land copy of the stream library from Node.js v0.10.x";
        homepage = https://github.com/isaacs/readable-stream;
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
    "readable-stream-~1.0.26" = self."readable-stream-1.0.33";
    "bl-~0.9.0" = self."bl-0.9.3";
    "caseless-0.7.0" = buildNodePackage {
      name = "caseless";
      version = "0.7.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.7.0.tgz";
        sha1 = "cbd705ae6229158bb0bc971bf7d7a04bdbd51ff8";
      };
      meta = {
        description = "Caseless object set/get/has, very useful when working with HTTP headers.";
        homepage = https://github.com/mikeal/caseless;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "caseless-~0.7.0" = self."caseless-0.7.0";
    "forever-agent-0.5.2" = buildNodePackage {
      name = "forever-agent";
      version = "0.5.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
        sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
      };
      dependencies = {};
      meta = {
        description = "HTTP Agent that keeps socket connections alive between keep-alive requests. Formerly part of mikeal/request, now a standalone module.";
        homepage = https://github.com/mikeal/forever-agent;
      };
      production = true;
      linkDependencies = false;
    };
    "forever-agent-~0.5.0" = self."forever-agent-0.5.2";
    "form-data-0.1.4" = buildNodePackage {
      name = "form-data";
      version = "0.1.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.4.tgz";
        sha1 = "91abd788aba9702b1aabfa8bc01031a2ac9e3b12";
      };
      dependencies = {
        combined-stream = {
          "~0.0.4" = {
            version = "0.0.7";
            pkg = self."combined-stream-0.0.7";
          };
        };
        mime = {
          "~1.2.11" = {
            version = "1.2.11";
            pkg = self."mime-1.2.11";
          };
        };
        async = {
          "~0.9.0" = {
            version = "0.9.0";
            pkg = self."async-0.9.0";
          };
        };
      };
      meta = {
        description = "A module to create readable \"multipart/form-data\" streams.  Can be used to submit forms and file uploads to other web applications.";
        homepage = https://github.com/felixge/node-form-data;
      };
      production = true;
      linkDependencies = false;
    };
    "combined-stream-0.0.7" = buildNodePackage {
      name = "combined-stream";
      version = "0.0.7";
      src = fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
        sha1 = "0137e657baa5a7541c57ac37ac5fc07d73b4dc1f";
      };
      dependencies = {
        delayed-stream = {
          "0.0.5" = {
            version = "0.0.5";
            pkg = self."delayed-stream-0.0.5";
          };
        };
      };
      meta = {
        description = "A stream that emits multiple other streams one after another.";
        homepage = https://github.com/felixge/node-combined-stream;
      };
      production = true;
      linkDependencies = false;
    };
    "delayed-stream-0.0.5" = buildNodePackage {
      name = "delayed-stream";
      version = "0.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
        sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
      };
      dependencies = {};
      meta = {
        description = "Buffers events from a stream until you are ready to handle them.";
        homepage = https://github.com/felixge/node-delayed-stream;
      };
      production = true;
      linkDependencies = false;
    };
    "combined-stream-~0.0.4" = self."combined-stream-0.0.7";
    "mime-1.2.11" = buildNodePackage {
      name = "mime";
      version = "1.2.11";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      };
      dependencies = {};
      meta = {
        description = "A comprehensive library for mime-type mapping";
      };
      production = true;
      linkDependencies = false;
    };
    "mime-~1.2.11" = self."mime-1.2.11";
    "async-0.9.0" = buildNodePackage {
      name = "async";
      version = "0.9.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
        sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
      };
      meta = {
        description = "Higher-order functions and common patterns for asynchronous code";
        homepage = https://github.com/caolan/async;
      };
      production = true;
      linkDependencies = false;
    };
    "async-~0.9.0" = self."async-0.9.0";
    "form-data-~0.1.0" = self."form-data-0.1.4";
    "json-stringify-safe-5.0.0" = buildNodePackage {
      name = "json-stringify-safe";
      version = "5.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
        sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
      };
      meta = {
        description = "Like JSON.stringify, but doesn't blow up on circular refs";
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "json-stringify-safe-~5.0.0" = self."json-stringify-safe-5.0.0";
    "mime-types-1.0.2" = buildNodePackage {
      name = "mime-types";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-1.0.2.tgz";
        sha1 = "995ae1392ab8affcbfcb2641dd054e943c0d5dce";
      };
      meta = {
        description = "The ultimate javascript content-type utility.";
        homepage = https://github.com/expressjs/mime-types;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mime-types-~1.0.1" = self."mime-types-1.0.2";
    "node-uuid-1.4.1" = buildNodePackage {
      name = "node-uuid";
      version = "1.4.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
      };
      meta = {
        description = "Rigorous implementation of RFC4122 (v1 and v4) UUIDs.";
      };
      production = true;
      linkDependencies = false;
    };
    "node-uuid-~1.4.0" = self."node-uuid-1.4.1";
    "qs-2.3.3" = buildNodePackage {
      name = "qs";
      version = "2.3.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.3.3.tgz";
        sha1 = "e9e85adbe75da0bbe4c8e0476a086290f863b404";
      };
      dependencies = {};
      meta = {
        description = "A querystring parser that supports nesting and arrays, with a depth limit";
        homepage = https://github.com/hapijs/qs;
      };
      production = true;
      linkDependencies = false;
    };
    "qs-~2.3.1" = self."qs-2.3.3";
    "tunnel-agent-0.4.0" = buildNodePackage {
      name = "tunnel-agent";
      version = "0.4.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.0.tgz";
        sha1 = "b1184e312ffbcf70b3b4c78e8c219de7ebb1c550";
      };
      dependencies = {};
      meta = {
        description = "HTTP proxy tunneling agent. Formerly part of mikeal/request, now a standalone module.";
        homepage = https://github.com/mikeal/tunnel-agent;
      };
      production = true;
      linkDependencies = false;
    };
    "tunnel-agent-~0.4.0" = self."tunnel-agent-0.4.0";
    "tough-cookie-0.12.1" = buildNodePackage {
      name = "tough-cookie";
      version = "0.12.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
        sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
      };
      dependencies = {
        punycode = {
          ">=0.2.0" = {
            version = "1.3.2";
            pkg = self."punycode-1.3.2";
          };
        };
      };
      meta = {
        description = "RFC6265 Cookies and Cookie Jar for node.js";
        homepage = https://github.com/goinstant/tough-cookie;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "punycode-1.3.2" = buildNodePackage {
      name = "punycode";
      version = "1.3.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
        sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
      };
      meta = {
        description = "A robust Punycode converter that fully complies to RFC 3492 and RFC 5891, and works on nearly all JavaScript platforms.";
        homepage = https://mths.be/punycode;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "punycode->=0.2.0" = self."punycode-1.3.2";
    "tough-cookie->=0.12.0" = self."tough-cookie-0.12.1";
    "http-signature-0.10.0" = buildNodePackage {
      name = "http-signature";
      version = "0.10.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.0.tgz";
        sha1 = "1494e4f5000a83c0f11bcc12d6007c530cb99582";
      };
      dependencies = {
        assert-plus = {
          "0.1.2" = {
            version = "0.1.2";
            pkg = self."assert-plus-0.1.2";
          };
        };
        asn1 = {
          "0.1.11" = {
            version = "0.1.11";
            pkg = self."asn1-0.1.11";
          };
        };
        ctype = {
          "0.5.2" = {
            version = "0.5.2";
            pkg = self."ctype-0.5.2";
          };
        };
      };
      meta = {
        description = "Reference implementation of Joyent's HTTP Signature Scheme";
      };
      production = true;
      linkDependencies = false;
    };
    "assert-plus-0.1.2" = buildNodePackage {
      name = "assert-plus";
      version = "0.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.2.tgz";
        sha1 = "d93ffdbb67ac5507779be316a7d65146417beef8";
      };
      dependencies = {};
      meta = {
        description = "Extra assertions on top of node's assert module";
      };
      production = true;
      linkDependencies = false;
    };
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
    "ctype-0.5.2" = buildNodePackage {
      name = "ctype";
      version = "0.5.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
        sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
      };
      meta = {
        description = "read and write binary structures and data types";
        homepage = https://github.com/rmustacc/node-ctype;
      };
      production = true;
      linkDependencies = false;
    };
    "http-signature-~0.10.0" = self."http-signature-0.10.0";
    "oauth-sign-0.5.0" = buildNodePackage {
      name = "oauth-sign";
      version = "0.5.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.5.0.tgz";
        sha1 = "d767f5169325620eab2e087ef0c472e773db6461";
      };
      dependencies = {};
      meta = {
        description = "OAuth 1 signing. Formerly a vendor lib in mikeal/request, now a standalone module.";
        homepage = https://github.com/mikeal/oauth-sign;
      };
      production = true;
      linkDependencies = false;
    };
    "oauth-sign-~0.5.0" = self."oauth-sign-0.5.0";
    "hawk-1.1.1" = buildNodePackage {
      name = "hawk";
      version = "1.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.1.1.tgz";
        sha1 = "87cd491f9b46e4e2aeaca335416766885d2d1ed9";
      };
      dependencies = {
        hoek = {
          "0.9.x" = {
            version = "0.9.1";
            pkg = self."hoek-0.9.1";
          };
        };
        boom = {
          "0.4.x" = {
            version = "0.4.2";
            pkg = self."boom-0.4.2";
          };
        };
        cryptiles = {
          "0.2.x" = {
            version = "0.2.2";
            pkg = self."cryptiles-0.2.2";
          };
        };
        sntp = {
          "0.2.x" = {
            version = "0.2.4";
            pkg = self."sntp-0.2.4";
          };
        };
      };
      meta = {
        description = "HTTP Hawk Authentication Scheme";
      };
      production = true;
      linkDependencies = false;
    };
    "hoek-0.9.1" = buildNodePackage {
      name = "hoek";
      version = "0.9.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
        sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
      };
      dependencies = {};
      meta = {
        description = "General purpose node utilities";
      };
      production = true;
      linkDependencies = false;
    };
    "hoek-0.9.x" = self."hoek-0.9.1";
    "boom-0.4.2" = buildNodePackage {
      name = "boom";
      version = "0.4.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
        sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
      };
      dependencies = {
        hoek = {
          "0.9.x" = {
            version = "0.9.1";
            pkg = self."hoek-0.9.1";
          };
        };
      };
      meta = {
        description = "HTTP-friendly error objects";
      };
      production = true;
      linkDependencies = false;
    };
    "boom-0.4.x" = self."boom-0.4.2";
    "cryptiles-0.2.2" = buildNodePackage {
      name = "cryptiles";
      version = "0.2.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
        sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
      };
      dependencies = {
        boom = {
          "0.4.x" = {
            version = "0.4.2";
            pkg = self."boom-0.4.2";
          };
        };
      };
      meta = {
        description = "General purpose crypto utilities";
      };
      production = true;
      linkDependencies = false;
    };
    "cryptiles-0.2.x" = self."cryptiles-0.2.2";
    "sntp-0.2.4" = buildNodePackage {
      name = "sntp";
      version = "0.2.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
        sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
      };
      dependencies = {
        hoek = {
          "0.9.x" = {
            version = "0.9.1";
            pkg = self."hoek-0.9.1";
          };
        };
      };
      meta = {
        description = "SNTP Client";
      };
      production = true;
      linkDependencies = false;
    };
    "sntp-0.2.x" = self."sntp-0.2.4";
    "aws-sign2-0.5.0" = buildNodePackage {
      name = "aws-sign2";
      version = "0.5.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
        sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
      };
      dependencies = {};
      meta = {
        description = "AWS signing. Originally pulled from LearnBoost/knox, maintained as vendor in request, now a standalone module.";
      };
      production = true;
      linkDependencies = false;
    };
    "aws-sign2-~0.5.0" = self."aws-sign2-0.5.0";
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
    "combined-stream-~0.0.5" = self."combined-stream-0.0.7";
    "request-2 >=2.25.0" = self."request-2.48.0";
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
    "rimraf-~2" = self."rimraf-2.2.8";
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
    "npmlog-0.1.1" = buildNodePackage {
      name = "npmlog";
      version = "0.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.1.1.tgz";
        sha1 = "8b9b9e4405d7ec48c31c2346965aadc7abaecaa5";
      };
      dependencies = {
        ansi = {
          "~0.3.0" = {
            version = "0.3.0";
            pkg = self."ansi-0.3.0";
          };
        };
      };
      meta = {
        description = "logger for npm";
        homepage = https://github.com/isaacs/npmlog;
        license = "BSD";
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
    npmlog = self."npmlog-0.1.1";
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
            version = "1.1.8";
            pkg = self."config-chain-1.1.8";
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
            version = "1.3.2";
            pkg = self."ini-1.3.2";
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
            version = "3.0.1";
            pkg = self."nopt-3.0.1";
          };
        };
        once = {
          "~1.3.0" = {
            version = "1.3.1";
            pkg = self."once-1.3.1";
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
            version = "4.1.0";
            pkg = self."semver-4.1.0";
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
    "config-chain-1.1.8" = buildNodePackage {
      name = "config-chain";
      version = "1.1.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/config-chain/-/config-chain-1.1.8.tgz";
        sha1 = "0943d0b7227213a20d4eaff4434f4a1c0a052cad";
      };
      dependencies = {
        proto-list = {
          "~1.2.1" = {
            version = "1.2.3";
            pkg = self."proto-list-1.2.3";
          };
        };
        ini = {
          "1" = {
            version = "1.3.2";
            pkg = self."ini-1.3.2";
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
    "proto-list-1.2.3" = buildNodePackage {
      name = "proto-list";
      version = "1.2.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/proto-list/-/proto-list-1.2.3.tgz";
        sha1 = "6235554a1bca1f0d15e3ca12ca7329d5def42bd9";
      };
      meta = {
        description = "A utility for managing a prototype chain";
        homepage = https://github.com/isaacs/proto-list;
        license = {
          type = "MIT";
          url = "https://github.com/isaacs/proto-list/blob/master/LICENSE";
        };
      };
      production = true;
      linkDependencies = false;
    };
    "proto-list-~1.2.1" = self."proto-list-1.2.3";
    "ini-1.3.2" = buildNodePackage {
      name = "ini";
      version = "1.3.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.3.2.tgz";
        sha1 = "9ebf4a44daf9d89acd07aab9f89a083d887f6dec";
      };
      dependencies = {};
      meta = {
        description = "An ini encoder/decoder for node";
        homepage = https://github.com/isaacs/ini;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    ini-1 = self."ini-1.3.2";
    "config-chain-~1.1.8" = self."config-chain-1.1.8";
    "inherits-~2.0.0" = self."inherits-2.0.1";
    "ini-^1.2.0" = self."ini-1.3.2";
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
    "nopt-3.0.1" = buildNodePackage {
      name = "nopt";
      version = "3.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-3.0.1.tgz";
        sha1 = "bce5c42446a3291f47622a370abbf158fbbacbfd";
      };
      dependencies = {
        abbrev = {
          "1" = {
            version = "1.0.5";
            pkg = self."abbrev-1.0.5";
          };
        };
      };
      meta = {
        description = "Option parsing for Node, supporting types, shorthands, etc. Used by npm.";
        homepage = https://github.com/isaacs/nopt;
        license = {
          type = "MIT";
          url = "https://github.com/isaacs/nopt/raw/master/LICENSE";
        };
      };
      production = true;
      linkDependencies = false;
    };
    "abbrev-1.0.5" = buildNodePackage {
      name = "abbrev";
      version = "1.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.5.tgz";
        sha1 = "5d8257bd9ebe435e698b2fa431afde4fe7b10b03";
      };
      meta = {
        description = "Like ruby's abbrev module, but in js";
        homepage = https://github.com/isaacs/abbrev-js;
        license = {
          type = "MIT";
          url = "https://github.com/isaacs/abbrev-js/raw/master/LICENSE";
        };
      };
      production = true;
      linkDependencies = false;
    };
    abbrev-1 = self."abbrev-1.0.5";
    "nopt-~3.0.1" = self."nopt-3.0.1";
    "once-1.3.1" = buildNodePackage {
      name = "once";
      version = "1.3.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.1.tgz";
        sha1 = "f3f3e4da5b7d27b5c732969ee3e67e729457b31f";
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
        homepage = https://github.com/isaacs/once;
        license = "BSD";
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
    "once-~1.3.0" = self."once-1.3.1";
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
    "semver-4.1.0" = buildNodePackage {
      name = "semver";
      version = "4.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-4.1.0.tgz";
        sha1 = "bc80a9ff68532814362cc3cfda3c7b75ed9c321c";
      };
      meta = {
        description = "The semantic version parser used by npm.";
        homepage = https://github.com/isaacs/node-semver;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "semver-2 || 3 || 4" = self."semver-4.1.0";
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
    "tar-1.0.2" = buildNodePackage {
      name = "tar";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-1.0.2.tgz";
        sha1 = "8b0f6740f9946259de26a3ed9c9a22890dff023f";
      };
      dependencies = {
        block-stream = {
          "*" = {
            version = "0.0.7";
            pkg = self."block-stream-0.0.7";
          };
        };
        fstream = {
          "^1.0.2" = {
            version = "1.0.2";
            pkg = self."fstream-1.0.2";
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
    "block-stream-0.0.7" = buildNodePackage {
      name = "block-stream";
      version = "0.0.7";
      src = fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
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
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    block-stream = self."block-stream-0.0.7";
    "fstream-1.0.2" = buildNodePackage {
      name = "fstream";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-1.0.2.tgz";
        sha1 = "56930ff1b4d4d7b1a689c8656b3a11e744ab92c6";
      };
      dependencies = {
        graceful-fs = {
          "3" = {
            version = "3.0.4";
            pkg = self."graceful-fs-3.0.4";
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
            version = "0.5.0";
            pkg = self."mkdirp-0.5.0";
          };
        };
        rimraf = {
          "2" = {
            version = "2.2.8";
            pkg = self."rimraf-2.2.8";
          };
        };
      };
      meta = {
        description = "Advanced file system stream things";
        homepage = https://github.com/isaacs/fstream;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-fs-3.0.4" = buildNodePackage {
      name = "graceful-fs";
      version = "3.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.4.tgz";
        sha1 = "a0306d9b0940e0fc512d33b5df1014e88e0637a3";
      };
      meta = {
        description = "A drop-in replacement for fs, making various improvements.";
        homepage = https://github.com/isaacs/node-graceful-fs;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    graceful-fs-3 = self."graceful-fs-3.0.4";
    "mkdirp->=0.5 0" = self."mkdirp-0.5.0";
    rimraf-2 = self."rimraf-2.2.8";
    "fstream-^1.0.2" = self."fstream-1.0.2";
    inherits-2 = self."inherits-2.0.1";
    "tar-1.0.x" = self."tar-1.0.2";
    "temp-0.8.1" = buildNodePackage {
      name = "temp";
      version = "0.8.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.8.1.tgz";
        sha1 = "4b7b4ffde85bb09f2dd6ba6cc43b44213c94fd3a";
      };
      dependencies = {
        rimraf = {
          "~2.2.6" = {
            version = "2.2.8";
            pkg = self."rimraf-2.2.8";
          };
        };
      };
      meta = {
        description = "Temporary files and directories";
      };
      production = true;
      linkDependencies = false;
    };
    "rimraf-~2.2.6" = self."rimraf-2.2.8";
    "temp-0.8.x" = self."temp-0.8.1";
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
    "nijs-0.0.22" = buildNodePackage {
      name = "nijs";
      version = "0.0.22";
      src = fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.22.tgz";
        sha1 = "41f162cfd4b8e99b56da26b3170307381916718a";
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