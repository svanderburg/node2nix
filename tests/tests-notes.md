Notes about the testcases
=========================
NPM supports all kinds of dependency specifiers and can refer to packages
coming from all kinds of sources.

There are also many packages around that could potentialy trigger errors,
because they have properties with weird implications that not even the NPM
maintainers could initially think of.

For validation purposes, I could implement test cases from scratch, but this is
a lot of work. Instead, I took existing packages as test cases.

The test scenarios are captured in the `tests.json` file (that is translated by
`node2nix` into a set of Nix expressions).

This code snippet explains the purpose of each test package:

```javascript
[
  // Testcase for a frequently used package
  "async",
  // Testcase for a frequently used package
  "grunt-cli",
  // Testcase for a frequently used package
  "bower",
  // Testcase for a frequently used package
  "coffee-script",
  // Testcase for an exact version specifier
  { "nijs": "0.0.25" },
  // Testcase for a wildcard version specifier
  { "commander": "2.9.x" },
  // Testcase for a tag as a version specifier
  { "underscore": "latest" },
  // Testcase with a weird version specifier containing trailing 0s that can only be used with loose version dependency parsing
  { "esprima-fb": "~3001.0001.0000-dev-harmony-fb" },
  // Testcase for a HTTP URL
  { "semver": "http://registry.npmjs.org/semver/-/semver-5.0.3.tgz" },
  // Testcase for a generic Git over HTTPS URL
  { "express": "git+https://github.com/strongloop/express.git" },
  // Testcase for a generic Git over HTTPS URL referring to a specific revision
  { "express": "git+https://github.com/strongloop/express.git#ef7ad68" },
  // Testcase for a generic git over HTTPS URL referring to a branch name
  { "express": "git+https://github.com/strongloop/express.git#master" },
  // Test for a Git repository with sub modules
  { "js-sequence-diagrams": "git+https://github.com/codimd/js-sequence-diagrams.git" },
  // Testcase for a Github repository alias
  { "nijs": "svanderburg/nijs" },
  // Testcase for a Git service provider (in this case GitHub)
  { "lodash": "github:lodash/lodash" },
  // Testcase for a directory reference
  { "testb": "./testb" },
  // Testcase for a package with cyclic dependencies
  "es5-ext",
  // Testcase for a scoped package
  "@sindresorhus/df",
  // Testcase for a scoped package referring to a Git repository
  { "@bengotow/slate-edit-list": "github:bengotow/slate-edit-list" },
  // Testcase for a package with an external native dependency
  "node-libcurl",
  // Testcase for a package with native C code that needs to be compiled
  "libxmljs",
  // Testcase for a package with native C code and an Xcode-related workaround in node-gyp to make it compile on macOS
  { "bcrypt": "3.0.x" },
  // Testcase for an NPM alias
  { "next": "npm:@blitzjs/next@10.2.3-0.37.0" }
]
```
