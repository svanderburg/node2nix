{nodeEnv, fetchurl, fetchgit}:

let
  sources = {
    "lodash-4.8.2" = {
      name = "lodash";
      packageName = "lodash";
      version = "4.8.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash/-/lodash-4.8.2.tgz";
        sha1 = "478ad7ff648c3c71a2f6108e032c5c0cc40747df";
      };
    };
    "optparse-1.0.5" = {
      name = "optparse";
      packageName = "optparse";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/optparse/-/optparse-1.0.5.tgz";
        sha1 = "75e75a96506611eb1c65ba89018ff08a981e2c16";
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
    "graceful-readlink-1.0.1" = {
      name = "graceful-readlink";
      packageName = "graceful-readlink";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
    };
    "accepts-1.2.13" = {
      name = "accepts";
      packageName = "accepts";
      version = "1.2.13";
      src = fetchurl {
        url = "https://registry.npmjs.org/accepts/-/accepts-1.2.13.tgz";
        sha1 = "e5f1f3928c6d95fd96558c36ec3d9d0de4a6ecea";
      };
    };
    "array-flatten-1.1.1" = {
      name = "array-flatten";
      packageName = "array-flatten";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz";
        sha1 = "9a5f699051b1e7073328f2a008968b64ea2955d2";
      };
    };
    "content-disposition-0.5.1" = {
      name = "content-disposition";
      packageName = "content-disposition";
      version = "0.5.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.1.tgz";
        sha1 = "87476c6a67c8daa87e32e87616df883ba7fb071b";
      };
    };
    "content-type-1.0.1" = {
      name = "content-type";
      packageName = "content-type";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/content-type/-/content-type-1.0.1.tgz";
        sha1 = "a19d2247327dc038050ce622b7a154ec59c5e600";
      };
    };
    "cookie-0.1.5" = {
      name = "cookie";
      packageName = "cookie";
      version = "0.1.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/cookie/-/cookie-0.1.5.tgz";
        sha1 = "6ab9948a4b1ae21952cd2588530a4722d4044d7c";
      };
    };
    "cookie-signature-1.0.6" = {
      name = "cookie-signature";
      packageName = "cookie-signature";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz";
        sha1 = "e303a882b342cc3ee8ca513a79999734dab3ae2c";
      };
    };
    "debug-2.2.0" = {
      name = "debug";
      packageName = "debug";
      version = "2.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-2.2.0.tgz";
        sha1 = "f87057e995b1a1f6ae6a4960664137bc56f039da";
      };
    };
    "depd-1.1.0" = {
      name = "depd";
      packageName = "depd";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/depd/-/depd-1.1.0.tgz";
        sha1 = "e1bd82c6aab6ced965b97b88b17ed3e528ca18c3";
      };
    };
    "escape-html-1.0.3" = {
      name = "escape-html";
      packageName = "escape-html";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz";
        sha1 = "0258eae4d3d0c0974de1c169188ef0051d1d1988";
      };
    };
    "etag-1.7.0" = {
      name = "etag";
      packageName = "etag";
      version = "1.7.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/etag/-/etag-1.7.0.tgz";
        sha1 = "03d30b5f67dd6e632d2945d30d6652731a34d5d8";
      };
    };
    "finalhandler-0.4.1" = {
      name = "finalhandler";
      packageName = "finalhandler";
      version = "0.4.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/finalhandler/-/finalhandler-0.4.1.tgz";
        sha1 = "85a17c6c59a94717d262d61230d4b0ebe3d4a14d";
      };
    };
    "fresh-0.3.0" = {
      name = "fresh";
      packageName = "fresh";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fresh/-/fresh-0.3.0.tgz";
        sha1 = "651f838e22424e7566de161d8358caa199f83d4f";
      };
    };
    "merge-descriptors-1.0.1" = {
      name = "merge-descriptors";
      packageName = "merge-descriptors";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz";
        sha1 = "b00aaa556dd8b44568150ec9d1b953f3f90cbb61";
      };
    };
    "methods-1.1.2" = {
      name = "methods";
      packageName = "methods";
      version = "1.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-1.1.2.tgz";
        sha1 = "5529a4d67654134edcc5266656835b0f851afcee";
      };
    };
    "on-finished-2.3.0" = {
      name = "on-finished";
      packageName = "on-finished";
      version = "2.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz";
        sha1 = "20f1336481b083cd75337992a16971aa2d906947";
      };
    };
    "parseurl-1.3.1" = {
      name = "parseurl";
      packageName = "parseurl";
      version = "1.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/parseurl/-/parseurl-1.3.1.tgz";
        sha1 = "c8ab8c9223ba34888aa64a297b28853bec18da56";
      };
    };
    "path-to-regexp-0.1.7" = {
      name = "path-to-regexp";
      packageName = "path-to-regexp";
      version = "0.1.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz";
        sha1 = "df604178005f522f15eb4490e7247a1bfaa67f8c";
      };
    };
    "proxy-addr-1.0.10" = {
      name = "proxy-addr";
      packageName = "proxy-addr";
      version = "1.0.10";
      src = fetchurl {
        url = "https://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.10.tgz";
        sha1 = "0d40a82f801fc355567d2ecb65efe3f077f121c5";
      };
    };
    "qs-4.0.0" = {
      name = "qs";
      packageName = "qs";
      version = "4.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-4.0.0.tgz";
        sha1 = "c31d9b74ec27df75e543a86c78728ed8d4623607";
      };
    };
    "range-parser-1.0.3" = {
      name = "range-parser";
      packageName = "range-parser";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/range-parser/-/range-parser-1.0.3.tgz";
        sha1 = "6872823535c692e2c2a0103826afd82c2e0ff175";
      };
    };
    "send-0.13.1" = {
      name = "send";
      packageName = "send";
      version = "0.13.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/send/-/send-0.13.1.tgz";
        sha1 = "a30d5f4c82c8a9bae9ad00a1d9b1bdbe6f199ed7";
      };
    };
    "serve-static-1.10.2" = {
      name = "serve-static";
      packageName = "serve-static";
      version = "1.10.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/serve-static/-/serve-static-1.10.2.tgz";
        sha1 = "feb800d0e722124dd0b00333160c16e9caa8bcb3";
      };
    };
    "type-is-1.6.12" = {
      name = "type-is";
      packageName = "type-is";
      version = "1.6.12";
      src = fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.6.12.tgz";
        sha1 = "0352a9dfbfff040fe668cc153cc95829c354173e";
      };
    };
    "utils-merge-1.0.0" = {
      name = "utils-merge";
      packageName = "utils-merge";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
        sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
      };
    };
    "vary-1.0.1" = {
      name = "vary";
      packageName = "vary";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/vary/-/vary-1.0.1.tgz";
        sha1 = "99e4981566a286118dfb2b817357df7993376d10";
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
    "negotiator-0.5.3" = {
      name = "negotiator";
      packageName = "negotiator";
      version = "0.5.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/negotiator/-/negotiator-0.5.3.tgz";
        sha1 = "269d5c476810ec92edbe7b6c2f28316384f9a7e8";
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
    "ms-0.7.1" = {
      name = "ms";
      packageName = "ms";
      version = "0.7.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-0.7.1.tgz";
        sha1 = "9cd13c03adbff25b65effde7ce864ee952017098";
      };
    };
    "unpipe-1.0.0" = {
      name = "unpipe";
      packageName = "unpipe";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz";
        sha1 = "b2bf4ee8514aae6165b4817829d21b2ef49904ec";
      };
    };
    "ee-first-1.1.1" = {
      name = "ee-first";
      packageName = "ee-first";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz";
        sha1 = "590c61156b0ae2f4f0255732a158b266bc56b21d";
      };
    };
    "forwarded-0.1.0" = {
      name = "forwarded";
      packageName = "forwarded";
      version = "0.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
        sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
      };
    };
    "ipaddr.js-1.0.5" = {
      name = "ipaddr.js";
      packageName = "ipaddr.js";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.0.5.tgz";
        sha1 = "5fa78cf301b825c78abc3042d812723049ea23c7";
      };
    };
    "destroy-1.0.4" = {
      name = "destroy";
      packageName = "destroy";
      version = "1.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz";
        sha1 = "978857442c44749e4206613e37946205826abd80";
      };
    };
    "http-errors-1.3.1" = {
      name = "http-errors";
      packageName = "http-errors";
      version = "1.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/http-errors/-/http-errors-1.3.1.tgz";
        sha1 = "197e22cdebd4198585e8694ef6786197b91ed942";
      };
    };
    "mime-1.3.4" = {
      name = "mime";
      packageName = "mime";
      version = "1.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/mime/-/mime-1.3.4.tgz";
        sha1 = "115f9e3b6b3daf2959983cb38f149a2d40eb5d53";
      };
    };
    "statuses-1.2.1" = {
      name = "statuses";
      packageName = "statuses";
      version = "1.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/statuses/-/statuses-1.2.1.tgz";
        sha1 = "dded45cc18256d51ed40aec142489d5c61026d28";
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
    "media-typer-0.3.0" = {
      name = "media-typer";
      packageName = "media-typer";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      };
    };
    "content-disposition-0.5.0" = {
      name = "content-disposition";
      packageName = "content-disposition";
      version = "0.5.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.0.tgz";
        sha1 = "4284fe6ae0630874639e44e80a418c2934135e9e";
      };
    };
    "cookie-0.1.3" = {
      name = "cookie";
      packageName = "cookie";
      version = "0.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/cookie/-/cookie-0.1.3.tgz";
        sha1 = "e734a5c1417fce472d5aef82c381cabb64d1a435";
      };
    };
    "depd-1.0.1" = {
      name = "depd";
      packageName = "depd";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/depd/-/depd-1.0.1.tgz";
        sha1 = "80aec64c9d6d97e65cc2a9caa93c0aa6abf73aaa";
      };
    };
    "escape-html-1.0.2" = {
      name = "escape-html";
      packageName = "escape-html";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-html/-/escape-html-1.0.2.tgz";
        sha1 = "d77d32fa98e38c2f41ae85e9278e0e0e6ba1022c";
      };
    };
    "finalhandler-0.4.0" = {
      name = "finalhandler";
      packageName = "finalhandler";
      version = "0.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/finalhandler/-/finalhandler-0.4.0.tgz";
        sha1 = "965a52d9e8d05d2b857548541fb89b53a2497d9b";
      };
    };
    "merge-descriptors-1.0.0" = {
      name = "merge-descriptors";
      packageName = "merge-descriptors";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.0.tgz";
        sha1 = "2169cf7538e1b0cc87fb88e1502d8474bbf79864";
      };
    };
    "send-0.13.0" = {
      name = "send";
      packageName = "send";
      version = "0.13.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/send/-/send-0.13.0.tgz";
        sha1 = "518f921aeb0560aec7dcab2990b14cf6f3cce5de";
      };
    };
    "destroy-1.0.3" = {
      name = "destroy";
      packageName = "destroy";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
        sha1 = "b433b4724e71fd8551d9885174851c5fc377e2c9";
      };
    };
    "testa-../testa" = {
      name = "testa";
      packageName = "testa";
      version = "0.0.1";
      src = ./testa;
    };
    "es6-iterator-2.0.0" = {
      name = "es6-iterator";
      packageName = "es6-iterator";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.0.tgz";
        sha1 = "bd968567d61635e33c0b80727613c9cb4b096bac";
      };
    };
    "es6-symbol-3.0.2" = {
      name = "es6-symbol";
      packageName = "es6-symbol";
      version = "3.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.0.2.tgz";
        sha1 = "1e928878c6f5e63541625b4bb4df4af07d154219";
      };
    };
    "d-0.1.1" = {
      name = "d";
      packageName = "d";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/d/-/d-0.1.1.tgz";
        sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
      };
    };
    "es5-ext-0.10.11" = {
      name = "es5-ext";
      packageName = "es5-ext";
      version = "0.10.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.11.tgz";
        sha1 = "8184c3e705a820948c2dbe043849379b1dbd0c45";
      };
    };
    "findup-sync-0.3.0" = {
      name = "findup-sync";
      packageName = "findup-sync";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/findup-sync/-/findup-sync-0.3.0.tgz";
        sha1 = "37930aa5d816b777c03445e1966cc6790a4c0b16";
      };
    };
    "grunt-known-options-1.1.0" = {
      name = "grunt-known-options";
      packageName = "grunt-known-options";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/grunt-known-options/-/grunt-known-options-1.1.0.tgz";
        sha1 = "a4274eeb32fa765da5a7a3b1712617ce3b144149";
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
    "resolve-1.1.7" = {
      name = "resolve";
      packageName = "resolve";
      version = "1.1.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz";
        sha1 = "203114d82ad2c5ed9e8e0411b3932875e889e97b";
      };
    };
    "glob-5.0.15" = {
      name = "glob";
      packageName = "glob";
      version = "5.0.15";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-5.0.15.tgz";
        sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
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
    "once-1.3.3" = {
      name = "once";
      packageName = "once";
      version = "1.3.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.3.tgz";
        sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
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
    "wrappy-1.0.1" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
        sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
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
    "abbrev-1.0.7" = {
      name = "abbrev";
      packageName = "abbrev";
      version = "1.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/abbrev/-/abbrev-1.0.7.tgz";
        sha1 = "5b6035b2ee9d4fb5cf859f08a9be81b208491843";
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
    "dmp-0.1.1" = {
      name = "dmp";
      packageName = "dmp";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/dmp/-/dmp-0.1.1.tgz";
        sha1 = "2cdd404b239b24b0c2342ab893b73bc15450cd07";
      };
    };
    "floorine-0.3.0" = {
      name = "floorine";
      packageName = "floorine";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/floorine/-/floorine-0.3.0.tgz";
        sha1 = "cfc23a889d629a22db04ba4b8ce357012d0f1e70";
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
    "open-0.0.5" = {
      name = "open";
      packageName = "open";
      version = "0.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/open/-/open-0.0.5.tgz";
        sha1 = "42c3e18ec95466b6bf0dc42f3a2945c3f0cad8fc";
      };
    };
    "optimist-0.6.1" = {
      name = "optimist";
      packageName = "optimist";
      version = "0.6.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
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
    "fsevents-1.0.11" = {
      name = "fsevents";
      packageName = "fsevents";
      version = "1.0.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/fsevents/-/fsevents-1.0.11.tgz";
        sha1 = "303d4051e411a95a7ad187e6f8ccffe936ca78ac";
      };
    };
    "native-diff-match-patch-0.3.1" = {
      name = "native-diff-match-patch";
      packageName = "native-diff-match-patch";
      version = "0.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/native-diff-match-patch/-/native-diff-match-patch-0.3.1.tgz";
        sha1 = "620304151a78171386ed2e2f3db2e7dfd6436707";
      };
    };
    "strftime-0.9.2" = {
      name = "strftime";
      packageName = "strftime";
      version = "0.9.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/strftime/-/strftime-0.9.2.tgz";
        sha1 = "bcca2861f29456d372aaf6a17811c8bc6f39f583";
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
    "wordwrap-0.0.3" = {
      name = "wordwrap";
      packageName = "wordwrap";
      version = "0.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz";
        sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
      };
    };
    "minimist-0.0.10" = {
      name = "minimist";
      packageName = "minimist";
      version = "0.0.10";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
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
    "delayed-stream-1.0.0" = {
      name = "delayed-stream";
      packageName = "delayed-stream";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
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
    "nan-2.2.1" = {
      name = "nan";
      packageName = "nan";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/nan/-/nan-2.2.1.tgz";
        sha1 = "d68693f6b34bb41d66bc68b3a4f9defc79d7149b";
      };
    };
    "node-pre-gyp-0.6.25" = {
      name = "node-pre-gyp";
      packageName = "node-pre-gyp";
      version = "0.6.25";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-pre-gyp/-/node-pre-gyp-0.6.25.tgz";
        sha1 = "2c6818775e6f1df5e353ba8024f1c0118726545b";
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
    "semver-5.1.0" = {
      name = "semver";
      packageName = "semver";
      version = "5.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-5.1.0.tgz";
        sha1 = "85f2cf8550465c4df000cf7d86f6b054106ab9e5";
      };
    };
    "tar-2.2.1" = {
      name = "tar";
      packageName = "tar";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/tar/-/tar-2.2.1.tgz";
        sha1 = "8e4d2a256c0e2185c6b18ad694aec968b83cb1d1";
      };
    };
    "tar-pack-3.1.3" = {
      name = "tar-pack";
      packageName = "tar-pack";
      version = "3.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tar-pack/-/tar-pack-3.1.3.tgz";
        sha1 = "611b7e62eb2f27aeda64554f7a7fb48900c7e157";
      };
    };
    "rc-1.1.6" = {
      name = "rc";
      packageName = "rc";
      version = "1.1.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/rc/-/rc-1.1.6.tgz";
        sha1 = "43651b76b6ae53b5c802f1151fa3fc3b059969c9";
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
    "graceful-fs-4.1.3" = {
      name = "graceful-fs";
      packageName = "graceful-fs";
      version = "4.1.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.3.tgz";
        sha1 = "92033ce11113c41e2628d61fdfa40bc10dc0155c";
      };
    };
    "fstream-ignore-1.0.3" = {
      name = "fstream-ignore";
      packageName = "fstream-ignore";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/fstream-ignore/-/fstream-ignore-1.0.3.tgz";
        sha1 = "4c74d91fa88b22b42f4f86a18a2820dd79d8fcdd";
      };
    };
    "uid-number-0.0.6" = {
      name = "uid-number";
      packageName = "uid-number";
      version = "0.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/uid-number/-/uid-number-0.0.6.tgz";
        sha1 = "0ea10e8035e8eb5b8e4449f06da1c730663baa81";
      };
    };
    "deep-extend-0.4.1" = {
      name = "deep-extend";
      packageName = "deep-extend";
      version = "0.4.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/deep-extend/-/deep-extend-0.4.1.tgz";
        sha1 = "efe4113d08085f4e6f9687759810f807469e2253";
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
    "minimist-1.2.0" = {
      name = "minimist";
      packageName = "minimist";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz";
        sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
      };
    };
    "strip-json-comments-1.0.4" = {
      name = "strip-json-comments";
      packageName = "strip-json-comments";
      version = "1.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-1.0.4.tgz";
        sha1 = "1e15fbcac97d3ee99bf2d73b4c656b082bbafb91";
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
  };
in
{
  async = nodeEnv.buildNodePackage {
    name = "async";
    packageName = "async";
    version = "2.0.0-rc.2";
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-2.0.0-rc.2.tgz";
      sha1 = "6fc56eec72574ebfe43ad30aefef6206f1ad2494";
    };
    dependencies = [
      sources."lodash-4.8.2"
    ];
    meta = {
      description = "Higher-order functions and common patterns for asynchronous code";
      homepage = "https://github.com/caolan/async#readme";
      license = "MIT";
    };
    production = true;
  };
  "nijs-0.0.23" = nodeEnv.buildNodePackage {
    name = "nijs";
    packageName = "nijs";
    version = "0.0.23";
    src = fetchurl {
      url = "https://registry.npmjs.org/nijs/-/nijs-0.0.23.tgz";
      sha1 = "dbf8f4a0acafbe3b8d9b71c24cbd1d851de6c31a";
    };
    dependencies = [
      sources."optparse-1.0.5"
      sources."slasp-0.0.4"
    ];
    meta = {
      description = "An internal DSL for the Nix package manager in JavaScript";
      homepage = https://github.com/svanderburg/nijs;
      license = "MIT";
    };
    production = true;
  };
  "commander-2.9.x" = nodeEnv.buildNodePackage {
    name = "commander";
    packageName = "commander";
    version = "2.9.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
      sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
    };
    dependencies = [
      sources."graceful-readlink-1.0.1"
    ];
    meta = {
      description = "the complete solution for node.js command-line programs";
      homepage = "https://github.com/tj/commander.js#readme";
      license = "MIT";
    };
    production = true;
  };
  underscore = nodeEnv.buildNodePackage {
    name = "underscore";
    packageName = "underscore";
    version = "1.8.3";
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore/-/underscore-1.8.3.tgz";
      sha1 = "4f3fb53b106e6097fcf9cb4109f2a5e9bdfa5022";
    };
    meta = {
      description = "JavaScript's functional programming helper library.";
      homepage = http://underscorejs.org/;
      license = "MIT";
    };
    production = true;
  };
  "semver-http://registry.npmjs.org/semver/-/semver-5.0.3.tgz" = nodeEnv.buildNodePackage {
    name = "semver";
    packageName = "semver";
    version = "5.0.3";
    src = fetchurl {
      name = "semver-5.0.3.tar.gz";
      url = http://registry.npmjs.org/semver/-/semver-5.0.3.tgz;
      sha256 = "131385bf0466cecc69e5bbf3c0a8f41174b8c832aa2e9b40f37cb4f4ad8c47f1";
    };
    meta = {
      description = "The semantic version parser used by npm.";
      license = "ISC";
    };
    production = true;
  };
  "express-git+https://github.com/strongloop/express.git" = nodeEnv.buildNodePackage {
    name = "express";
    packageName = "express";
    version = "4.13.4";
    src = fetchgit {
      url = "https://github.com/strongloop/express.git";
      rev = "f3d99a4fdbe1531ea609e92c4d4ae6c269d78c7a";
      sha256 = "7ee3a9c2f749aa726e34b2931bb503e18d92c2ecc00af0667e925bfb83e31237";
    };
    dependencies = [
      (sources."accepts-1.2.13" // {
        dependencies = [
          (sources."mime-types-2.1.10" // {
            dependencies = [
              sources."mime-db-1.22.0"
            ];
          })
          sources."negotiator-0.5.3"
        ];
      })
      sources."array-flatten-1.1.1"
      sources."content-disposition-0.5.1"
      sources."content-type-1.0.1"
      sources."cookie-0.1.5"
      sources."cookie-signature-1.0.6"
      (sources."debug-2.2.0" // {
        dependencies = [
          sources."ms-0.7.1"
        ];
      })
      sources."depd-1.1.0"
      sources."escape-html-1.0.3"
      sources."etag-1.7.0"
      (sources."finalhandler-0.4.1" // {
        dependencies = [
          sources."unpipe-1.0.0"
        ];
      })
      sources."fresh-0.3.0"
      sources."merge-descriptors-1.0.1"
      sources."methods-1.1.2"
      (sources."on-finished-2.3.0" // {
        dependencies = [
          sources."ee-first-1.1.1"
        ];
      })
      sources."parseurl-1.3.1"
      sources."path-to-regexp-0.1.7"
      (sources."proxy-addr-1.0.10" // {
        dependencies = [
          sources."forwarded-0.1.0"
          sources."ipaddr.js-1.0.5"
        ];
      })
      sources."qs-4.0.0"
      sources."range-parser-1.0.3"
      (sources."send-0.13.1" // {
        dependencies = [
          sources."destroy-1.0.4"
          (sources."http-errors-1.3.1" // {
            dependencies = [
              sources."inherits-2.0.1"
            ];
          })
          sources."mime-1.3.4"
          sources."ms-0.7.1"
          sources."statuses-1.2.1"
        ];
      })
      sources."serve-static-1.10.2"
      (sources."type-is-1.6.12" // {
        dependencies = [
          sources."media-typer-0.3.0"
          (sources."mime-types-2.1.10" // {
            dependencies = [
              sources."mime-db-1.22.0"
            ];
          })
        ];
      })
      sources."utils-merge-1.0.0"
      sources."vary-1.0.1"
    ];
    meta = {
      description = "Fast, unopinionated, minimalist web framework";
      homepage = http://expressjs.com/;
      license = "MIT";
    };
    production = true;
  };
  "express-git+https://github.com/strongloop/express.git#ef7ad68" = nodeEnv.buildNodePackage {
    name = "express";
    packageName = "express";
    version = "4.13.3";
    src = fetchgit {
      url = "https://github.com/strongloop/express.git";
      rev = "ef7ad681b245fba023843ce94f6bcb8e275bbb8e";
      sha256 = "bac097e9f127efa0516db51395becf639ccee5581e07d42268291a9fbab13017";
    };
    dependencies = [
      (sources."accepts-1.2.13" // {
        dependencies = [
          (sources."mime-types-2.1.10" // {
            dependencies = [
              sources."mime-db-1.22.0"
            ];
          })
          sources."negotiator-0.5.3"
        ];
      })
      sources."array-flatten-1.1.1"
      sources."content-disposition-0.5.0"
      sources."content-type-1.0.1"
      sources."cookie-0.1.3"
      sources."cookie-signature-1.0.6"
      (sources."debug-2.2.0" // {
        dependencies = [
          sources."ms-0.7.1"
        ];
      })
      sources."depd-1.0.1"
      sources."escape-html-1.0.2"
      sources."etag-1.7.0"
      (sources."finalhandler-0.4.0" // {
        dependencies = [
          sources."unpipe-1.0.0"
        ];
      })
      sources."fresh-0.3.0"
      sources."merge-descriptors-1.0.0"
      sources."methods-1.1.2"
      (sources."on-finished-2.3.0" // {
        dependencies = [
          sources."ee-first-1.1.1"
        ];
      })
      sources."parseurl-1.3.1"
      sources."path-to-regexp-0.1.7"
      (sources."proxy-addr-1.0.10" // {
        dependencies = [
          sources."forwarded-0.1.0"
          sources."ipaddr.js-1.0.5"
        ];
      })
      sources."qs-4.0.0"
      sources."range-parser-1.0.3"
      (sources."send-0.13.0" // {
        dependencies = [
          sources."destroy-1.0.3"
          (sources."http-errors-1.3.1" // {
            dependencies = [
              sources."inherits-2.0.1"
            ];
          })
          sources."mime-1.3.4"
          sources."ms-0.7.1"
          sources."statuses-1.2.1"
        ];
      })
      (sources."serve-static-1.10.2" // {
        dependencies = [
          sources."escape-html-1.0.3"
          (sources."send-0.13.1" // {
            dependencies = [
              sources."depd-1.1.0"
              sources."destroy-1.0.4"
              (sources."http-errors-1.3.1" // {
                dependencies = [
                  sources."inherits-2.0.1"
                ];
              })
              sources."mime-1.3.4"
              sources."ms-0.7.1"
              sources."statuses-1.2.1"
            ];
          })
        ];
      })
      (sources."type-is-1.6.12" // {
        dependencies = [
          sources."media-typer-0.3.0"
          (sources."mime-types-2.1.10" // {
            dependencies = [
              sources."mime-db-1.22.0"
            ];
          })
        ];
      })
      sources."utils-merge-1.0.0"
      sources."vary-1.0.1"
    ];
    meta = {
      description = "Fast, unopinionated, minimalist web framework";
      homepage = http://expressjs.com/;
      license = "MIT";
    };
    production = true;
  };
  "express-git+https://github.com/strongloop/express.git#master" = nodeEnv.buildNodePackage {
    name = "express";
    packageName = "express";
    version = "4.13.4";
    src = fetchgit {
      url = "https://github.com/strongloop/express.git";
      rev = "f3d99a4fdbe1531ea609e92c4d4ae6c269d78c7a";
      sha256 = "7ee3a9c2f749aa726e34b2931bb503e18d92c2ecc00af0667e925bfb83e31237";
    };
    dependencies = [
      (sources."accepts-1.2.13" // {
        dependencies = [
          (sources."mime-types-2.1.10" // {
            dependencies = [
              sources."mime-db-1.22.0"
            ];
          })
          sources."negotiator-0.5.3"
        ];
      })
      sources."array-flatten-1.1.1"
      sources."content-disposition-0.5.1"
      sources."content-type-1.0.1"
      sources."cookie-0.1.5"
      sources."cookie-signature-1.0.6"
      (sources."debug-2.2.0" // {
        dependencies = [
          sources."ms-0.7.1"
        ];
      })
      sources."depd-1.1.0"
      sources."escape-html-1.0.3"
      sources."etag-1.7.0"
      (sources."finalhandler-0.4.1" // {
        dependencies = [
          sources."unpipe-1.0.0"
        ];
      })
      sources."fresh-0.3.0"
      sources."merge-descriptors-1.0.1"
      sources."methods-1.1.2"
      (sources."on-finished-2.3.0" // {
        dependencies = [
          sources."ee-first-1.1.1"
        ];
      })
      sources."parseurl-1.3.1"
      sources."path-to-regexp-0.1.7"
      (sources."proxy-addr-1.0.10" // {
        dependencies = [
          sources."forwarded-0.1.0"
          sources."ipaddr.js-1.0.5"
        ];
      })
      sources."qs-4.0.0"
      sources."range-parser-1.0.3"
      (sources."send-0.13.1" // {
        dependencies = [
          sources."destroy-1.0.4"
          (sources."http-errors-1.3.1" // {
            dependencies = [
              sources."inherits-2.0.1"
            ];
          })
          sources."mime-1.3.4"
          sources."ms-0.7.1"
          sources."statuses-1.2.1"
        ];
      })
      sources."serve-static-1.10.2"
      (sources."type-is-1.6.12" // {
        dependencies = [
          sources."media-typer-0.3.0"
          (sources."mime-types-2.1.10" // {
            dependencies = [
              sources."mime-db-1.22.0"
            ];
          })
        ];
      })
      sources."utils-merge-1.0.0"
      sources."vary-1.0.1"
    ];
    meta = {
      description = "Fast, unopinionated, minimalist web framework";
      homepage = http://expressjs.com/;
      license = "MIT";
    };
    production = true;
  };
  "nijs-svanderburg/nijs" = nodeEnv.buildNodePackage {
    name = "nijs";
    packageName = "nijs";
    version = "0.0.23";
    src = fetchgit {
      url = "git://github.com/svanderburg/nijs";
      rev = "fc1898aa497f7d7b4d9621bf3107405156109221";
      sha256 = "782998c4e4cf3a064e29bbe2683e8ff6c748b85c4d9f13f9f0ae56b15bdd24f3";
    };
    dependencies = [
      sources."optparse-1.0.5"
      sources."slasp-0.0.4"
    ];
    meta = {
      description = "An internal DSL for the Nix package manager in JavaScript";
      license = "MIT";
    };
    production = true;
  };
  "lodash-github:lodash/lodash" = nodeEnv.buildNodePackage {
    name = "lodash";
    packageName = "lodash";
    version = "4.8.2";
    src = fetchgit {
      url = "git://github.com/lodash/lodash";
      rev = "d7f43eba6a47778837d2037675555ee972a7be73";
      sha256 = "fb62622030e5cbb2033538f4fb2ccc99a9ffb4606315a9ebeeb56ac92560f4ab";
    };
    meta = {
      license = "MIT";
    };
    production = true;
  };
  "testb-./testb" = nodeEnv.buildNodePackage {
    name = "testb";
    packageName = "testb";
    version = "0.0.1";
    src = ./testb;
    dependencies = [
      sources."testa-../testa"
    ];
    meta = {
    };
    production = true;
  };
  es5-ext = nodeEnv.buildNodePackage {
    name = "es5-ext";
    packageName = "es5-ext";
    version = "0.10.11";
    src = fetchurl {
      url = "https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.11.tgz";
      sha1 = "8184c3e705a820948c2dbe043849379b1dbd0c45";
    };
    dependencies = [
      (sources."es6-iterator-2.0.0" // {
        dependencies = [
          sources."d-0.1.1"
          sources."es5-ext-0.10.11"
        ];
      })
      (sources."es6-symbol-3.0.2" // {
        dependencies = [
          sources."d-0.1.1"
          sources."es5-ext-0.10.11"
        ];
      })
    ];
    meta = {
      description = "ECMAScript extensions and shims";
      homepage = "https://github.com/medikoo/es5-ext#readme";
      license = "MIT";
    };
    production = true;
  };
  grunt-cli = nodeEnv.buildNodePackage {
    name = "grunt-cli";
    packageName = "grunt-cli";
    version = "1.2.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.2.0.tgz";
      sha1 = "562b119ebb069ddb464ace2845501be97b35b6a8";
    };
    dependencies = [
      (sources."findup-sync-0.3.0" // {
        dependencies = [
          (sources."glob-5.0.15" // {
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
      sources."grunt-known-options-1.1.0"
      (sources."nopt-3.0.6" // {
        dependencies = [
          sources."abbrev-1.0.7"
        ];
      })
      sources."resolve-1.1.7"
    ];
    meta = {
      description = "The grunt command line interface";
      homepage = "https://github.com/gruntjs/grunt-cli#readme";
      license = "MIT";
    };
    production = true;
  };
  bower = nodeEnv.buildNodePackage {
    name = "bower";
    packageName = "bower";
    version = "1.7.9";
    src = fetchurl {
      url = "https://registry.npmjs.org/bower/-/bower-1.7.9.tgz";
      sha1 = "b7296c2393e0d75edaa6ca39648132dd255812b0";
    };
    meta = {
      description = "The browser package manager";
      homepage = http://bower.io/;
      license = "MIT";
    };
    production = true;
  };
  coffee-script = nodeEnv.buildNodePackage {
    name = "coffee-script";
    packageName = "coffee-script";
    version = "1.10.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/coffee-script/-/coffee-script-1.10.0.tgz";
      sha1 = "12938bcf9be1948fa006f92e0c4c9e81705108c0";
    };
    meta = {
      description = "Unfancy JavaScript";
      homepage = http://coffeescript.org/;
      license = "MIT";
    };
    production = true;
  };
  floomatic = nodeEnv.buildNodePackage {
    name = "floomatic";
    packageName = "floomatic";
    version = "0.5.3";
    src = fetchurl {
      url = "https://registry.npmjs.org/floomatic/-/floomatic-0.5.3.tgz";
      sha1 = "d7a5aa8709300758d51f4de4be1f4e6fa1389050";
    };
    dependencies = [
      sources."async-1.5.2"
      sources."dmp-0.1.1"
      (sources."floorine-0.3.0" // {
        dependencies = [
          sources."strftime-0.9.2"
        ];
      })
      sources."lodash-4.8.2"
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
      (sources."mkdirp-0.5.1" // {
        dependencies = [
          sources."minimist-0.0.8"
        ];
      })
      sources."open-0.0.5"
      (sources."optimist-0.6.1" // {
        dependencies = [
          sources."wordwrap-0.0.3"
          sources."minimist-0.0.10"
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
          sources."form-data-1.0.0-rc4"
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
      (sources."fsevents-1.0.11" // {
        dependencies = [
          sources."nan-2.2.1"
          (sources."node-pre-gyp-0.6.25" // {
            dependencies = [
              (sources."nopt-3.0.6" // {
                dependencies = [
                  sources."abbrev-1.0.7"
                ];
              })
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
              sources."semver-5.1.0"
              (sources."tar-2.2.1" // {
                dependencies = [
                  sources."block-stream-0.0.8"
                  (sources."fstream-1.0.8" // {
                    dependencies = [
                      sources."graceful-fs-4.1.3"
                    ];
                  })
                  sources."inherits-2.0.1"
                ];
              })
              (sources."tar-pack-3.1.3" // {
                dependencies = [
                  (sources."debug-2.2.0" // {
                    dependencies = [
                      sources."ms-0.7.1"
                    ];
                  })
                  (sources."fstream-1.0.8" // {
                    dependencies = [
                      sources."graceful-fs-4.1.3"
                      sources."inherits-2.0.1"
                    ];
                  })
                  (sources."fstream-ignore-1.0.3" // {
                    dependencies = [
                      sources."inherits-2.0.1"
                    ];
                  })
                  (sources."once-1.3.3" // {
                    dependencies = [
                      sources."wrappy-1.0.1"
                    ];
                  })
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
                  sources."uid-number-0.0.6"
                ];
              })
              (sources."rc-1.1.6" // {
                dependencies = [
                  sources."deep-extend-0.4.1"
                  sources."ini-1.3.4"
                  sources."minimist-1.2.0"
                  sources."strip-json-comments-1.0.4"
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
                      sources."inherits-2.0.1"
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
        ];
      })
      sources."native-diff-match-patch-0.3.1"
    ];
    meta = {
      description = "A headless [Floobits](https://floobits.com/) workspace and disk watcher. Handy for shipping changes to a testing server.";
      homepage = https://github.com/Floobits/floomatic/;
      license = "Apache-2.0";
    };
    production = true;
  };
  "@sindresorhus/df" = nodeEnv.buildNodePackage {
    name = "_at_sindresorhus_slash_df";
    packageName = "@sindresorhus/df";
    version = "1.0.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/@sindresorhus/df/-/df-1.0.1.tgz";
      sha1 = "c69b66f52f6fcdd287c807df210305dbaf78500d";
    };
    meta = {
      description = "Get free disk space info from `df -kP`";
      homepage = "https://github.com/sindresorhus/df#readme";
      license = "MIT";
    };
    production = true;
  };
}