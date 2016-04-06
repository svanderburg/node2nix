{nodeEnv, fetchurl, fetchgit}:

let
  sources = {
    "optparse-1.0.5" = {
      name = "optparse";
      packageName = "optparse";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/optparse/-/optparse-1.0.5.tgz";
        sha1 = "75e75a96506611eb1c65ba89018ff08a981e2c16";
      };
    };
    "semver-5.0.3" = {
      name = "semver";
      packageName = "semver";
      version = "5.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-5.0.3.tgz";
        sha1 = "77466de589cd5d3c95f138aa78bc569a3cb5d27a";
      };
    };
    "npm-registry-client-7.1.0" = {
      name = "npm-registry-client";
      packageName = "npm-registry-client";
      version = "7.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/npm-registry-client/-/npm-registry-client-7.1.0.tgz";
        sha1 = "e3be14ab279fe5123e15ab5c8a650445415664a5";
      };
    };
    "npmconf-2.0.9" = {
      name = "npmconf";
      packageName = "npmconf";
      version = "2.0.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/npmconf/-/npmconf-2.0.9.tgz";
        sha1 = "5c87e5fb308104eceeca781e3d9115d216351ef2";
      };
    };
    "tar-1.0.3" = {
      name = "tar";
      packageName = "tar";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tar/-/tar-1.0.3.tgz";
        sha1 = "15bcdab244fa4add44e4244a0176edb8aa9a2b44";
      };
    };
    "temp-0.8.3" = {
      name = "temp";
      packageName = "temp";
      version = "0.8.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/temp/-/temp-0.8.3.tgz";
        sha1 = "e0c6bc4d26b903124410e4fed81103014dfc1f59";
      };
    };
    "fs.extra-1.2.1" = {
      name = "fs.extra";
      packageName = "fs.extra";
      version = "1.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs.extra/-/fs.extra-1.2.1.tgz";
        sha1 = "060bf20264f35e39ad247e5e9d2121a2a75a1733";
      };
    };
    "findit-2.0.0" = {
      name = "findit";
      packageName = "findit";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/findit/-/findit-2.0.0.tgz";
        sha1 = "6509f0126af4c178551cfa99394e032e13a4d56e";
      };
    };
    "slasp-0.0.4" = {
      name = "slasp";
      packageName = "slasp";
      version = "0.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/slasp/-/slasp-0.0.4.tgz";
        sha1 = "9adc26ee729a0f95095851a5489f87a5258d57a9";
      };
    };
    "nijs-0.0.23" = {
      name = "nijs";
      packageName = "nijs";
      version = "0.0.23";
      src = fetchurl {
        url = "https://registry.npmjs.org/nijs/-/nijs-0.0.23.tgz";
        sha1 = "dbf8f4a0acafbe3b8d9b71c24cbd1d851de6c31a";
      };
    };
    "chownr-1.0.1" = {
      name = "chownr";
      packageName = "chownr";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/chownr/-/chownr-1.0.1.tgz";
        sha1 = "e2a75042a9551908bebd25b8523d5f9769d79181";
      };
    };
    "concat-stream-1.5.1" = {
      name = "concat-stream";
      packageName = "concat-stream";
      version = "1.5.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.5.1.tgz";
        sha1 = "f3b80acf9e1f48e3875c0688b41b6c31602eea1c";
      };
    };
    "graceful-fs-4.1.3" = {
      name = "graceful-fs";
      packageName = "graceful-fs";
      version = "4.1.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.3.tgz";
        sha1 = "92033ce11113c41e2628d61fdfa40bc10dc0155c";
      };
    };
    "mkdirp-0.5.1" = {
      name = "mkdirp";
      packageName = "mkdirp";
      version = "0.5.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
        sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
      };
    };
    "normalize-package-data-2.3.5" = {
      name = "normalize-package-data";
      packageName = "normalize-package-data";
      version = "2.3.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.3.5.tgz";
        sha1 = "8d924f142960e1777e7ffe170543631cc7cb02df";
      };
    };
    "npm-package-arg-4.1.0" = {
      name = "npm-package-arg";
      packageName = "npm-package-arg";
      version = "4.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/npm-package-arg/-/npm-package-arg-4.1.0.tgz";
        sha1 = "2e015f8ac00737cb97f997c9cbf059f42a74527d";
      };
    };
    "once-1.3.3" = {
      name = "once";
      packageName = "once";
      version = "1.3.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.3.tgz";
        sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
      };
    };
    "request-2.70.0" = {
      name = "request";
      packageName = "request";
      version = "2.70.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/request/-/request-2.70.0.tgz";
        sha1 = "7ecf8437d6fb553e92e2981a411b9ee2aadd7cce";
      };
    };
    "retry-0.8.0" = {
      name = "retry";
      packageName = "retry";
      version = "0.8.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/retry/-/retry-0.8.0.tgz";
        sha1 = "2367628dc0edb247b1eab649dc53ac8628ac2d5f";
      };
    };
    "rimraf-2.5.2" = {
      name = "rimraf";
      packageName = "rimraf";
      version = "2.5.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/rimraf/-/rimraf-2.5.2.tgz";
        sha1 = "62ba947fa4c0b4363839aefecd4f0fbad6059726";
      };
    };
    "slide-1.1.6" = {
      name = "slide";
      packageName = "slide";
      version = "1.1.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/slide/-/slide-1.1.6.tgz";
        sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
      };
    };
    "npmlog-2.0.3" = {
      name = "npmlog";
      packageName = "npmlog";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/npmlog/-/npmlog-2.0.3.tgz";
        sha1 = "020f99351f0c02e399c674ba256e7c4d3b3dd298";
      };
    };
    "inherits-2.0.1" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      };
    };
    "typedarray-0.0.6" = {
      name = "typedarray";
      packageName = "typedarray";
      version = "0.0.6";
      src = fetchurl {
        url = "http://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      };
    };
    "readable-stream-2.0.6" = {
      name = "readable-stream";
      packageName = "readable-stream";
      version = "2.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.0.6.tgz";
        sha1 = "8f90341e68a53ccc928788dacfcd11b36eb9b78e";
      };
    };
    "core-util-is-1.0.2" = {
      name = "core-util-is";
      packageName = "core-util-is";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    };
    "isarray-1.0.0" = {
      name = "isarray";
      packageName = "isarray";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    };
    "process-nextick-args-1.0.6" = {
      name = "process-nextick-args";
      packageName = "process-nextick-args";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.6.tgz";
        sha1 = "0f96b001cea90b12592ce566edb97ec11e69bd05";
      };
    };
    "string_decoder-0.10.31" = {
      name = "string_decoder";
      packageName = "string_decoder";
      version = "0.10.31";
      src = fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
    };
    "util-deprecate-1.0.2" = {
      name = "util-deprecate";
      packageName = "util-deprecate";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    };
    "minimist-0.0.8" = {
      name = "minimist";
      packageName = "minimist";
      version = "0.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      };
    };
    "hosted-git-info-2.1.4" = {
      name = "hosted-git-info";
      packageName = "hosted-git-info";
      version = "2.1.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.1.4.tgz";
        sha1 = "d9e953b26988be88096c46e926494d9604c300f8";
      };
    };
    "is-builtin-module-1.0.0" = {
      name = "is-builtin-module";
      packageName = "is-builtin-module";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-1.0.0.tgz";
        sha1 = "540572d34f7ac3119f8f76c30cbc1b1e037affbe";
      };
    };
    "validate-npm-package-license-3.0.1" = {
      name = "validate-npm-package-license";
      packageName = "validate-npm-package-license";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.1.tgz";
        sha1 = "2804babe712ad3379459acfbe24746ab2c303fbc";
      };
    };
    "builtin-modules-1.1.1" = {
      name = "builtin-modules";
      packageName = "builtin-modules";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/builtin-modules/-/builtin-modules-1.1.1.tgz";
        sha1 = "270f076c5a72c02f5b65a47df94c5fe3a278892f";
      };
    };
    "spdx-correct-1.0.2" = {
      name = "spdx-correct";
      packageName = "spdx-correct";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/spdx-correct/-/spdx-correct-1.0.2.tgz";
        sha1 = "4b3073d933ff51f3912f03ac5519498a4150db40";
      };
    };
    "spdx-expression-parse-1.0.2" = {
      name = "spdx-expression-parse";
      packageName = "spdx-expression-parse";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-1.0.2.tgz";
        sha1 = "d52b14b5e9670771440af225bcb563122ac452f6";
      };
    };
    "spdx-license-ids-1.2.0" = {
      name = "spdx-license-ids";
      packageName = "spdx-license-ids";
      version = "1.2.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-1.2.0.tgz";
        sha1 = "b549dd0f63dcb745a17e2ea3a07402e0e332d1e2";
      };
    };
    "spdx-exceptions-1.0.4" = {
      name = "spdx-exceptions";
      packageName = "spdx-exceptions";
      version = "1.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-1.0.4.tgz";
        sha1 = "220b84239119ae9045a892db81a83f4ce16f80fd";
      };
    };
    "wrappy-1.0.1" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
        sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
      };
    };
    "aws-sign2-0.6.0" = {
      name = "aws-sign2";
      packageName = "aws-sign2";
      version = "0.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz";
        sha1 = "14342dd38dbcc94d0e5b87d763cd63612c0e794f";
      };
    };
    "aws4-1.3.2" = {
      name = "aws4";
      packageName = "aws4";
      version = "1.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/aws4/-/aws4-1.3.2.tgz";
        sha1 = "d39e0bee412ced0e8ed94a23e314f313a95b9fd1";
      };
    };
    "bl-1.1.2" = {
      name = "bl";
      packageName = "bl";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/bl/-/bl-1.1.2.tgz";
        sha1 = "fdca871a99713aa00d19e3bbba41c44787a65398";
      };
    };
    "caseless-0.11.0" = {
      name = "caseless";
      packageName = "caseless";
      version = "0.11.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
        sha1 = "715b96ea9841593cc33067923f5ec60ebda4f7d7";
      };
    };
    "combined-stream-1.0.5" = {
      name = "combined-stream";
      packageName = "combined-stream";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
        sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
      };
    };
    "extend-3.0.0" = {
      name = "extend";
      packageName = "extend";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
        sha1 = "5a474353b9f3353ddd8176dfd37b91c83a46f1d4";
      };
    };
    "forever-agent-0.6.1" = {
      name = "forever-agent";
      packageName = "forever-agent";
      version = "0.6.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
    };
    "form-data-1.0.0-rc4" = {
      name = "form-data";
      packageName = "form-data";
      version = "1.0.0-rc4";
      src = fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc4.tgz";
        sha1 = "05ac6bc22227b43e4461f488161554699d4f8b5e";
      };
    };
    "har-validator-2.0.6" = {
      name = "har-validator";
      packageName = "har-validator";
      version = "2.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/har-validator/-/har-validator-2.0.6.tgz";
        sha1 = "cdcbc08188265ad119b6a5a7c8ab70eecfb5d27d";
      };
    };
    "hawk-3.1.3" = {
      name = "hawk";
      packageName = "hawk";
      version = "3.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/hawk/-/hawk-3.1.3.tgz";
        sha1 = "078444bd7c1640b0fe540d2c9b73d59678e8e1c4";
      };
    };
    "http-signature-1.1.1" = {
      name = "http-signature";
      packageName = "http-signature";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/http-signature/-/http-signature-1.1.1.tgz";
        sha1 = "df72e267066cd0ac67fb76adf8e134a8fbcf91bf";
      };
    };
    "is-typedarray-1.0.0" = {
      name = "is-typedarray";
      packageName = "is-typedarray";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz";
        sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
      };
    };
    "isstream-0.1.2" = {
      name = "isstream";
      packageName = "isstream";
      version = "0.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    };
    "json-stringify-safe-5.0.1" = {
      name = "json-stringify-safe";
      packageName = "json-stringify-safe";
      version = "5.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    };
    "mime-types-2.1.10" = {
      name = "mime-types";
      packageName = "mime-types";
      version = "2.1.10";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.10.tgz";
        sha1 = "b93c7cb4362e16d41072a7e54538fb4d43070837";
      };
    };
    "node-uuid-1.4.7" = {
      name = "node-uuid";
      packageName = "node-uuid";
      version = "1.4.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-uuid/-/node-uuid-1.4.7.tgz";
        sha1 = "6da5a17668c4b3dd59623bda11cf7fa4c1f60a6f";
      };
    };
    "oauth-sign-0.8.1" = {
      name = "oauth-sign";
      packageName = "oauth-sign";
      version = "0.8.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.1.tgz";
        sha1 = "182439bdb91378bf7460e75c64ea43e6448def06";
      };
    };
    "qs-6.1.0" = {
      name = "qs";
      packageName = "qs";
      version = "6.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-6.1.0.tgz";
        sha1 = "ec1d1626b24278d99f0fdf4549e524e24eceeb26";
      };
    };
    "stringstream-0.0.5" = {
      name = "stringstream";
      packageName = "stringstream";
      version = "0.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
        sha1 = "4e484cd4de5a0bbbee18e46307710a8a81621878";
      };
    };
    "tough-cookie-2.2.2" = {
      name = "tough-cookie";
      packageName = "tough-cookie";
      version = "2.2.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.2.2.tgz";
        sha1 = "c83a1830f4e5ef0b93ef2a3488e724f8de016ac7";
      };
    };
    "tunnel-agent-0.4.2" = {
      name = "tunnel-agent";
      packageName = "tunnel-agent";
      version = "0.4.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.2.tgz";
        sha1 = "1104e3f36ac87125c287270067d582d18133bfee";
      };
    };
    "lru-cache-4.0.1" = {
      name = "lru-cache";
      packageName = "lru-cache";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/lru-cache/-/lru-cache-4.0.1.tgz";
        sha1 = "1343955edaf2e37d9b9e7ee7241e27c4b9fb72be";
      };
    };
    "pseudomap-1.0.2" = {
      name = "pseudomap";
      packageName = "pseudomap";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz";
        sha1 = "f052a28da70e618917ef0a8ac34c1ae5a68286b3";
      };
    };
    "yallist-2.0.0" = {
      name = "yallist";
      packageName = "yallist";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/yallist/-/yallist-2.0.0.tgz";
        sha1 = "306c543835f09ee1a4cb23b7bce9ab341c91cdd4";
      };
    };
    "delayed-stream-1.0.0" = {
      name = "delayed-stream";
      packageName = "delayed-stream";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
    };
    "async-1.5.2" = {
      name = "async";
      packageName = "async";
      version = "1.5.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/async/-/async-1.5.2.tgz";
        sha1 = "ec6a61ae56480c0c3cb241c95618e20892f9672a";
      };
    };
    "chalk-1.1.3" = {
      name = "chalk";
      packageName = "chalk";
      version = "1.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz";
        sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
      };
    };
    "commander-2.9.0" = {
      name = "commander";
      packageName = "commander";
      version = "2.9.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
        sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
      };
    };
    "is-my-json-valid-2.13.1" = {
      name = "is-my-json-valid";
      packageName = "is-my-json-valid";
      version = "2.13.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.13.1.tgz";
        sha1 = "d55778a82feb6b0963ff4be111d5d1684e890707";
      };
    };
    "pinkie-promise-2.0.0" = {
      name = "pinkie-promise";
      packageName = "pinkie-promise";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.0.tgz";
        sha1 = "4c83538de1f6e660c29e0a13446844f7a7e88259";
      };
    };
    "ansi-styles-2.2.1" = {
      name = "ansi-styles";
      packageName = "ansi-styles";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz";
        sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
      };
    };
    "escape-string-regexp-1.0.5" = {
      name = "escape-string-regexp";
      packageName = "escape-string-regexp";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    };
    "has-ansi-2.0.0" = {
      name = "has-ansi";
      packageName = "has-ansi";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
    };
    "strip-ansi-3.0.1" = {
      name = "strip-ansi";
      packageName = "strip-ansi";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz";
        sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
      };
    };
    "supports-color-2.0.0" = {
      name = "supports-color";
      packageName = "supports-color";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
    };
    "ansi-regex-2.0.0" = {
      name = "ansi-regex";
      packageName = "ansi-regex";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
        sha1 = "c5061b6e0ef8a81775e50f5d66151bf6bf371107";
      };
    };
    "graceful-readlink-1.0.1" = {
      name = "graceful-readlink";
      packageName = "graceful-readlink";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
    };
    "generate-function-2.0.0" = {
      name = "generate-function";
      packageName = "generate-function";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
        sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
      };
    };
    "generate-object-property-1.2.0" = {
      name = "generate-object-property";
      packageName = "generate-object-property";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
        sha1 = "9c0e1c40308ce804f4783618b937fa88f99d50d0";
      };
    };
    "jsonpointer-2.0.0" = {
      name = "jsonpointer";
      packageName = "jsonpointer";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonpointer/-/jsonpointer-2.0.0.tgz";
        sha1 = "3af1dd20fe85463910d469a385e33017d2a030d9";
      };
    };
    "xtend-4.0.1" = {
      name = "xtend";
      packageName = "xtend";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
    };
    "is-property-1.0.2" = {
      name = "is-property";
      packageName = "is-property";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
        sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
      };
    };
    "pinkie-2.0.4" = {
      name = "pinkie";
      packageName = "pinkie";
      version = "2.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz";
        sha1 = "72556b80cfa0d48a974e80e77248e80ed4f7f870";
      };
    };
    "hoek-2.16.3" = {
      name = "hoek";
      packageName = "hoek";
      version = "2.16.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
        sha1 = "20bb7403d3cea398e91dc4710a8ff1b8274a25ed";
      };
    };
    "boom-2.10.1" = {
      name = "boom";
      packageName = "boom";
      version = "2.10.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/boom/-/boom-2.10.1.tgz";
        sha1 = "39c8918ceff5799f83f9492a848f625add0c766f";
      };
    };
    "cryptiles-2.0.5" = {
      name = "cryptiles";
      packageName = "cryptiles";
      version = "2.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
        sha1 = "3bdfecdc608147c1c67202fa291e7dca59eaa3b8";
      };
    };
    "sntp-1.0.9" = {
      name = "sntp";
      packageName = "sntp";
      version = "1.0.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
        sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
      };
    };
    "assert-plus-0.2.0" = {
      name = "assert-plus";
      packageName = "assert-plus";
      version = "0.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/assert-plus/-/assert-plus-0.2.0.tgz";
        sha1 = "d74e1b87e7affc0db8aadb7021f3fe48101ab234";
      };
    };
    "jsprim-1.2.2" = {
      name = "jsprim";
      packageName = "jsprim";
      version = "1.2.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsprim/-/jsprim-1.2.2.tgz";
        sha1 = "f20c906ac92abd58e3b79ac8bc70a48832512da1";
      };
    };
    "sshpk-1.7.4" = {
      name = "sshpk";
      packageName = "sshpk";
      version = "1.7.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/sshpk/-/sshpk-1.7.4.tgz";
        sha1 = "ad7b47defca61c8415d964243b62b0ce60fbca38";
      };
    };
    "extsprintf-1.0.2" = {
      name = "extsprintf";
      packageName = "extsprintf";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
        sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
      };
    };
    "json-schema-0.2.2" = {
      name = "json-schema";
      packageName = "json-schema";
      version = "0.2.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
        sha1 = "50354f19f603917c695f70b85afa77c3b0f23506";
      };
    };
    "verror-1.3.6" = {
      name = "verror";
      packageName = "verror";
      version = "1.3.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
        sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
      };
    };
    "asn1-0.2.3" = {
      name = "asn1";
      packageName = "asn1";
      version = "0.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz";
        sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
      };
    };
    "dashdash-1.13.0" = {
      name = "dashdash";
      packageName = "dashdash";
      version = "1.13.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/dashdash/-/dashdash-1.13.0.tgz";
        sha1 = "a5aae6fd9d8e156624eb0dd9259eb12ba245385a";
      };
    };
    "jsbn-0.1.0" = {
      name = "jsbn";
      packageName = "jsbn";
      version = "0.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsbn/-/jsbn-0.1.0.tgz";
        sha1 = "650987da0dd74f4ebf5a11377a2aa2d273e97dfd";
      };
    };
    "tweetnacl-0.14.3" = {
      name = "tweetnacl";
      packageName = "tweetnacl";
      version = "0.14.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.3.tgz";
        sha1 = "3da382f670f25ded78d7b3d1792119bca0b7132d";
      };
    };
    "jodid25519-1.0.2" = {
      name = "jodid25519";
      packageName = "jodid25519";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/jodid25519/-/jodid25519-1.0.2.tgz";
        sha1 = "06d4912255093419477d425633606e0e90782967";
      };
    };
    "ecc-jsbn-0.1.1" = {
      name = "ecc-jsbn";
      packageName = "ecc-jsbn";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
        sha1 = "0fc73a9ed5f0d53c38193398523ef7e543777505";
      };
    };
    "assert-plus-1.0.0" = {
      name = "assert-plus";
      packageName = "assert-plus";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz";
        sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
      };
    };
    "mime-db-1.22.0" = {
      name = "mime-db";
      packageName = "mime-db";
      version = "1.22.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/mime-db/-/mime-db-1.22.0.tgz";
        sha1 = "ab23a6372dc9d86d3dc9121bd0ebd38105a1904a";
      };
    };
    "glob-7.0.3" = {
      name = "glob";
      packageName = "glob";
      version = "7.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-7.0.3.tgz";
        sha1 = "0aa235931a4a96ac13d60ffac2fb877bd6ed4f58";
      };
    };
    "inflight-1.0.4" = {
      name = "inflight";
      packageName = "inflight";
      version = "1.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
        sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
      };
    };
    "minimatch-3.0.0" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.0.tgz";
        sha1 = "5236157a51e4f004c177fb3c527ff7dd78f0ef83";
      };
    };
    "path-is-absolute-1.0.0" = {
      name = "path-is-absolute";
      packageName = "path-is-absolute";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.0.tgz";
        sha1 = "263dada66ab3f2fb10bf7f9d24dd8f3e570ef912";
      };
    };
    "brace-expansion-1.1.3" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "1.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.3.tgz";
        sha1 = "46bff50115d47fc9ab89854abb87d98078a10991";
      };
    };
    "balanced-match-0.3.0" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-0.3.0.tgz";
        sha1 = "a91cdd1ebef1a86659e70ff4def01625fc2d6756";
      };
    };
    "concat-map-0.0.1" = {
      name = "concat-map";
      packageName = "concat-map";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    };
    "ansi-0.3.1" = {
      name = "ansi";
      packageName = "ansi";
      version = "0.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi/-/ansi-0.3.1.tgz";
        sha1 = "0c42d4fb17160d5a9af1e484bace1c66922c1b21";
      };
    };
    "are-we-there-yet-1.1.2" = {
      name = "are-we-there-yet";
      packageName = "are-we-there-yet";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.1.2.tgz";
        sha1 = "80e470e95a084794fe1899262c5667c6e88de1b3";
      };
    };
    "gauge-1.2.7" = {
      name = "gauge";
      packageName = "gauge";
      version = "1.2.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/gauge/-/gauge-1.2.7.tgz";
        sha1 = "e9cec5483d3d4ee0ef44b60a7d99e4935e136d93";
      };
    };
    "delegates-1.0.0" = {
      name = "delegates";
      packageName = "delegates";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz";
        sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
      };
    };
    "has-unicode-2.0.0" = {
      name = "has-unicode";
      packageName = "has-unicode";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.0.tgz";
        sha1 = "a3cd96c307ba41d559c5a2ee408c12a11c4c2ec3";
      };
    };
    "lodash.pad-4.2.0" = {
      name = "lodash.pad";
      packageName = "lodash.pad";
      version = "4.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash.pad/-/lodash.pad-4.2.0.tgz";
        sha1 = "743e1adf26534d3e8cf3fba52a68aa4f48c38cd6";
      };
    };
    "lodash.padend-4.3.0" = {
      name = "lodash.padend";
      packageName = "lodash.padend";
      version = "4.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash.padend/-/lodash.padend-4.3.0.tgz";
        sha1 = "5333dccbcd88cdd651a05ba6e05f483ae287119f";
      };
    };
    "lodash.padstart-4.3.0" = {
      name = "lodash.padstart";
      packageName = "lodash.padstart";
      version = "4.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash.padstart/-/lodash.padstart-4.3.0.tgz";
        sha1 = "7044f6c4a3544165d2b5b3c2203834809fac692e";
      };
    };
    "lodash.tostring-4.1.2" = {
      name = "lodash.tostring";
      packageName = "lodash.tostring";
      version = "4.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash.tostring/-/lodash.tostring-4.1.2.tgz";
        sha1 = "7d326a5cf64da4298f2fd35b688d848267535288";
      };
    };
    "config-chain-1.1.10" = {
      name = "config-chain";
      packageName = "config-chain";
      version = "1.1.10";
      src = fetchurl {
        url = "https://registry.npmjs.org/config-chain/-/config-chain-1.1.10.tgz";
        sha1 = "7fc383de0fcc84d711cb465bd176579cad612346";
      };
    };
    "ini-1.3.4" = {
      name = "ini";
      packageName = "ini";
      version = "1.3.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.3.4.tgz";
        sha1 = "0537cb79daf59b59a1a517dff706c86ec039162e";
      };
    };
    "nopt-3.0.6" = {
      name = "nopt";
      packageName = "nopt";
      version = "3.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz";
        sha1 = "c6465dbf08abcd4db359317f79ac68a646b28ff9";
      };
    };
    "osenv-0.1.3" = {
      name = "osenv";
      packageName = "osenv";
      version = "0.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/osenv/-/osenv-0.1.3.tgz";
        sha1 = "83cf05c6d6458fc4d5ac6362ea325d92f2754217";
      };
    };
    "semver-4.3.6" = {
      name = "semver";
      packageName = "semver";
      version = "4.3.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-4.3.6.tgz";
        sha1 = "300bc6e0e86374f7ba61068b5b1ecd57fc6532da";
      };
    };
    "uid-number-0.0.5" = {
      name = "uid-number";
      packageName = "uid-number";
      version = "0.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/uid-number/-/uid-number-0.0.5.tgz";
        sha1 = "5a3db23ef5dbd55b81fce0ec9a2ac6fccdebb81e";
      };
    };
    "proto-list-1.2.4" = {
      name = "proto-list";
      packageName = "proto-list";
      version = "1.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz";
        sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
      };
    };
    "abbrev-1.0.7" = {
      name = "abbrev";
      packageName = "abbrev";
      version = "1.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/abbrev/-/abbrev-1.0.7.tgz";
        sha1 = "5b6035b2ee9d4fb5cf859f08a9be81b208491843";
      };
    };
    "os-homedir-1.0.1" = {
      name = "os-homedir";
      packageName = "os-homedir";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.1.tgz";
        sha1 = "0d62bdf44b916fd3bbdcf2cab191948fb094f007";
      };
    };
    "os-tmpdir-1.0.1" = {
      name = "os-tmpdir";
      packageName = "os-tmpdir";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.1.tgz";
        sha1 = "e9b423a1edaf479882562e92ed71d7743a071b6e";
      };
    };
    "block-stream-0.0.8" = {
      name = "block-stream";
      packageName = "block-stream";
      version = "0.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/block-stream/-/block-stream-0.0.8.tgz";
        sha1 = "0688f46da2bbf9cff0c4f68225a0cb95cbe8a46b";
      };
    };
    "fstream-1.0.8" = {
      name = "fstream";
      packageName = "fstream";
      version = "1.0.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/fstream/-/fstream-1.0.8.tgz";
        sha1 = "7e8d7a73abb3647ef36e4b8a15ca801dba03d038";
      };
    };
    "rimraf-2.2.8" = {
      name = "rimraf";
      packageName = "rimraf";
      version = "2.2.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      };
    };
    "mkdirp-0.3.5" = {
      name = "mkdirp";
      packageName = "mkdirp";
      version = "0.3.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      };
    };
    "fs-extra-0.6.4" = {
      name = "fs-extra";
      packageName = "fs-extra";
      version = "0.6.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-extra/-/fs-extra-0.6.4.tgz";
        sha1 = "f46f0c75b7841f8d200b3348cd4d691d5a099d15";
      };
    };
    "walk-2.2.1" = {
      name = "walk";
      packageName = "walk";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/walk/-/walk-2.2.1.tgz";
        sha1 = "5ada1f8e49e47d4b7445d8be7a2e1e631ab43016";
      };
    };
    "ncp-0.4.2" = {
      name = "ncp";
      packageName = "ncp";
      version = "0.4.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/ncp/-/ncp-0.4.2.tgz";
        sha1 = "abcc6cbd3ec2ed2a729ff6e7c1fa8f01784a8574";
      };
    };
    "jsonfile-1.0.1" = {
      name = "jsonfile";
      packageName = "jsonfile";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonfile/-/jsonfile-1.0.1.tgz";
        sha1 = "ea5efe40b83690b98667614a7392fc60e842c0dd";
      };
    };
    "forEachAsync-2.2.1" = {
      name = "forEachAsync";
      packageName = "forEachAsync";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/forEachAsync/-/forEachAsync-2.2.1.tgz";
        sha1 = "e3723f00903910e1eb4b1db3ad51b5c64a319fec";
      };
    };
    "sequence-2.2.1" = {
      name = "sequence";
      packageName = "sequence";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
        sha1 = "7f5617895d44351c0a047e764467690490a16b03";
      };
    };
  };
  args = {
    name = "npm2nix";
    packageName = "npm2nix";
    version = "6.0.0";
    src = ./.;
    dependencies = [
      sources."optparse-1.0.5"
      sources."semver-5.0.3"
      (sources."npm-registry-client-7.1.0" // {
        dependencies = [
          sources."chownr-1.0.1"
          (sources."concat-stream-1.5.1" // {
            dependencies = [
              sources."inherits-2.0.1"
              sources."typedarray-0.0.6"
              (sources."readable-stream-2.0.6" // {
                dependencies = [
                  sources."core-util-is-1.0.2"
                  sources."isarray-1.0.0"
                  sources."process-nextick-args-1.0.6"
                  sources."string_decoder-0.10.31"
                  sources."util-deprecate-1.0.2"
                ];
              })
            ];
          })
          sources."graceful-fs-4.1.3"
          (sources."mkdirp-0.5.1" // {
            dependencies = [
              sources."minimist-0.0.8"
            ];
          })
          (sources."normalize-package-data-2.3.5" // {
            dependencies = [
              sources."hosted-git-info-2.1.4"
              (sources."is-builtin-module-1.0.0" // {
                dependencies = [
                  sources."builtin-modules-1.1.1"
                ];
              })
              (sources."validate-npm-package-license-3.0.1" // {
                dependencies = [
                  (sources."spdx-correct-1.0.2" // {
                    dependencies = [
                      sources."spdx-license-ids-1.2.0"
                    ];
                  })
                  (sources."spdx-expression-parse-1.0.2" // {
                    dependencies = [
                      sources."spdx-exceptions-1.0.4"
                      sources."spdx-license-ids-1.2.0"
                    ];
                  })
                ];
              })
            ];
          })
          (sources."npm-package-arg-4.1.0" // {
            dependencies = [
              sources."hosted-git-info-2.1.4"
            ];
          })
          (sources."once-1.3.3" // {
            dependencies = [
              sources."wrappy-1.0.1"
            ];
          })
          (sources."request-2.70.0" // {
            dependencies = [
              sources."aws-sign2-0.6.0"
              (sources."aws4-1.3.2" // {
                dependencies = [
                  (sources."lru-cache-4.0.1" // {
                    dependencies = [
                      sources."pseudomap-1.0.2"
                      sources."yallist-2.0.0"
                    ];
                  })
                ];
              })
              (sources."bl-1.1.2" // {
                dependencies = [
                  (sources."readable-stream-2.0.6" // {
                    dependencies = [
                      sources."core-util-is-1.0.2"
                      sources."inherits-2.0.1"
                      sources."isarray-1.0.0"
                      sources."process-nextick-args-1.0.6"
                      sources."string_decoder-0.10.31"
                      sources."util-deprecate-1.0.2"
                    ];
                  })
                ];
              })
              sources."caseless-0.11.0"
              (sources."combined-stream-1.0.5" // {
                dependencies = [
                  sources."delayed-stream-1.0.0"
                ];
              })
              sources."extend-3.0.0"
              sources."forever-agent-0.6.1"
              (sources."form-data-1.0.0-rc4" // {
                dependencies = [
                  sources."async-1.5.2"
                ];
              })
              (sources."har-validator-2.0.6" // {
                dependencies = [
                  (sources."chalk-1.1.3" // {
                    dependencies = [
                      sources."ansi-styles-2.2.1"
                      sources."escape-string-regexp-1.0.5"
                      (sources."has-ansi-2.0.0" // {
                        dependencies = [
                          sources."ansi-regex-2.0.0"
                        ];
                      })
                      (sources."strip-ansi-3.0.1" // {
                        dependencies = [
                          sources."ansi-regex-2.0.0"
                        ];
                      })
                      sources."supports-color-2.0.0"
                    ];
                  })
                  (sources."commander-2.9.0" // {
                    dependencies = [
                      sources."graceful-readlink-1.0.1"
                    ];
                  })
                  (sources."is-my-json-valid-2.13.1" // {
                    dependencies = [
                      sources."generate-function-2.0.0"
                      (sources."generate-object-property-1.2.0" // {
                        dependencies = [
                          sources."is-property-1.0.2"
                        ];
                      })
                      sources."jsonpointer-2.0.0"
                      sources."xtend-4.0.1"
                    ];
                  })
                  (sources."pinkie-promise-2.0.0" // {
                    dependencies = [
                      sources."pinkie-2.0.4"
                    ];
                  })
                ];
              })
              (sources."hawk-3.1.3" // {
                dependencies = [
                  sources."hoek-2.16.3"
                  sources."boom-2.10.1"
                  sources."cryptiles-2.0.5"
                  sources."sntp-1.0.9"
                ];
              })
              (sources."http-signature-1.1.1" // {
                dependencies = [
                  sources."assert-plus-0.2.0"
                  (sources."jsprim-1.2.2" // {
                    dependencies = [
                      sources."extsprintf-1.0.2"
                      sources."json-schema-0.2.2"
                      sources."verror-1.3.6"
                    ];
                  })
                  (sources."sshpk-1.7.4" // {
                    dependencies = [
                      sources."asn1-0.2.3"
                      (sources."dashdash-1.13.0" // {
                        dependencies = [
                          sources."assert-plus-1.0.0"
                        ];
                      })
                      sources."jsbn-0.1.0"
                      sources."tweetnacl-0.14.3"
                      sources."jodid25519-1.0.2"
                      sources."ecc-jsbn-0.1.1"
                    ];
                  })
                ];
              })
              sources."is-typedarray-1.0.0"
              sources."isstream-0.1.2"
              sources."json-stringify-safe-5.0.1"
              (sources."mime-types-2.1.10" // {
                dependencies = [
                  sources."mime-db-1.22.0"
                ];
              })
              sources."node-uuid-1.4.7"
              sources."oauth-sign-0.8.1"
              sources."qs-6.1.0"
              sources."stringstream-0.0.5"
              sources."tough-cookie-2.2.2"
              sources."tunnel-agent-0.4.2"
            ];
          })
          sources."retry-0.8.0"
          (sources."rimraf-2.5.2" // {
            dependencies = [
              (sources."glob-7.0.3" // {
                dependencies = [
                  (sources."inflight-1.0.4" // {
                    dependencies = [
                      sources."wrappy-1.0.1"
                    ];
                  })
                  sources."inherits-2.0.1"
                  (sources."minimatch-3.0.0" // {
                    dependencies = [
                      (sources."brace-expansion-1.1.3" // {
                        dependencies = [
                          sources."balanced-match-0.3.0"
                          sources."concat-map-0.0.1"
                        ];
                      })
                    ];
                  })
                  sources."path-is-absolute-1.0.0"
                ];
              })
            ];
          })
          sources."slide-1.1.6"
          (sources."npmlog-2.0.3" // {
            dependencies = [
              sources."ansi-0.3.1"
              (sources."are-we-there-yet-1.1.2" // {
                dependencies = [
                  sources."delegates-1.0.0"
                  (sources."readable-stream-2.0.6" // {
                    dependencies = [
                      sources."core-util-is-1.0.2"
                      sources."inherits-2.0.1"
                      sources."isarray-1.0.0"
                      sources."process-nextick-args-1.0.6"
                      sources."string_decoder-0.10.31"
                      sources."util-deprecate-1.0.2"
                    ];
                  })
                ];
              })
              (sources."gauge-1.2.7" // {
                dependencies = [
                  sources."has-unicode-2.0.0"
                  (sources."lodash.pad-4.2.0" // {
                    dependencies = [
                      sources."lodash.tostring-4.1.2"
                    ];
                  })
                  (sources."lodash.padend-4.3.0" // {
                    dependencies = [
                      sources."lodash.tostring-4.1.2"
                    ];
                  })
                  (sources."lodash.padstart-4.3.0" // {
                    dependencies = [
                      sources."lodash.tostring-4.1.2"
                    ];
                  })
                ];
              })
            ];
          })
        ];
      })
      (sources."npmconf-2.0.9" // {
        dependencies = [
          (sources."config-chain-1.1.10" // {
            dependencies = [
              sources."proto-list-1.2.4"
            ];
          })
          sources."inherits-2.0.1"
          sources."ini-1.3.4"
          (sources."mkdirp-0.5.1" // {
            dependencies = [
              sources."minimist-0.0.8"
            ];
          })
          (sources."nopt-3.0.6" // {
            dependencies = [
              sources."abbrev-1.0.7"
            ];
          })
          (sources."once-1.3.3" // {
            dependencies = [
              sources."wrappy-1.0.1"
            ];
          })
          (sources."osenv-0.1.3" // {
            dependencies = [
              sources."os-homedir-1.0.1"
              sources."os-tmpdir-1.0.1"
            ];
          })
          sources."semver-4.3.6"
          sources."uid-number-0.0.5"
        ];
      })
      (sources."tar-1.0.3" // {
        dependencies = [
          sources."block-stream-0.0.8"
          (sources."fstream-1.0.8" // {
            dependencies = [
              sources."graceful-fs-4.1.3"
              (sources."mkdirp-0.5.1" // {
                dependencies = [
                  sources."minimist-0.0.8"
                ];
              })
              (sources."rimraf-2.5.2" // {
                dependencies = [
                  (sources."glob-7.0.3" // {
                    dependencies = [
                      (sources."inflight-1.0.4" // {
                        dependencies = [
                          sources."wrappy-1.0.1"
                        ];
                      })
                      (sources."minimatch-3.0.0" // {
                        dependencies = [
                          (sources."brace-expansion-1.1.3" // {
                            dependencies = [
                              sources."balanced-match-0.3.0"
                              sources."concat-map-0.0.1"
                            ];
                          })
                        ];
                      })
                      (sources."once-1.3.3" // {
                        dependencies = [
                          sources."wrappy-1.0.1"
                        ];
                      })
                      sources."path-is-absolute-1.0.0"
                    ];
                  })
                ];
              })
            ];
          })
          sources."inherits-2.0.1"
        ];
      })
      (sources."temp-0.8.3" // {
        dependencies = [
          sources."os-tmpdir-1.0.1"
          sources."rimraf-2.2.8"
        ];
      })
      (sources."fs.extra-1.2.1" // {
        dependencies = [
          sources."mkdirp-0.3.5"
          (sources."fs-extra-0.6.4" // {
            dependencies = [
              sources."ncp-0.4.2"
              sources."jsonfile-1.0.1"
              sources."rimraf-2.2.8"
            ];
          })
          (sources."walk-2.2.1" // {
            dependencies = [
              (sources."forEachAsync-2.2.1" // {
                dependencies = [
                  sources."sequence-2.2.1"
                ];
              })
            ];
          })
        ];
      })
      sources."findit-2.0.0"
      sources."slasp-0.0.4"
      sources."nijs-0.0.23"
    ];
    meta = {
      description = "Generate Nix expressions to build NPM packages";
      homepage = https://github.com/NixOS/npm2nix;
    };
    production = true;
  };
in
{
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
}