node2nix
========
Deploy [NPM Package Manager](http://www.npmjs.org) (NPM) packages with the
[Nix package manager](http://www.nixos.org/nix)!

Using `node2nix` instead of the "vanilla" NPM is useful for a variety of reasons:
* To deploy NPM packages on [NixOS](https://nixos.org) and to manage complex
  software installations (that include non-NPM managed dependencies) by using a
  universal deployment solution (Nix).
* To integrate with other tools in the Nix-ecosystem: NixOS to manage an entire
  system from a single declarative specification,
  [NixOps](https://nixos.org/nixops) to deploy networks of machines (bare metal
  and in the cloud), and [Disnix](https://nixos.org/disnix) to manage
  service-oriented systems.

Table of Contents
================
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [node2nix](#node2nix)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Building a development version](#building-a-development-version)
- [Usage](#usage)
    - [Deploying a Node.js development project](#deploying-a-nodejs-development-project)
    - [Generating a tarball from a Node.js development project](#generating-a-tarball-from-a-nodejs-development-project)
    - [Deploying a development environment of a Node.js development project](#deploying-a-development-environment-of-a-nodejs-development-project)
    - [Using the Node.js environment in other Nix derivations](#using-the-nodejs-environment-in-other-nix-derivations)
    - [Deploying a collection of NPM packages from the NPM registry](#deploying-a-collection-of-npm-packages-from-the-npm-registry)
    - [Using NPM lock files](#using-npm-lock-files)
    - [Generating packages for specific Node.js versions](#generating-packages-for-specific-nodejs-versions)
- [Advanced options](#advanced-options)
    - [Development mode](#development-mode)
    - [Specifying paths](#specifying-paths)
    - [Using alternative NPM registries](#using-alternative-npm-registries)
    - [Adding unspecified dependencies](#adding-unspecified-dependencies)
    - [Wrapping or patching the code or any of its dependencies](#wrapping-or-patching-the-code-or-any-of-its-dependencies)
    - [Adding additional/global NPM packages to a packaging process](#adding-additionalglobal-npm-packages-to-a-packaging-process)
    - [Using private Git repositories](#using-private-git-repositories)
    - [Disable cache bypassing](#disable-cache-bypassing)
- [Troubleshooting](#troubleshooting)
    - [Deploying peer dependencies](#deploying-peer-dependencies)
    - [Stripping optional dependencies](#striping-optional-dependencies)
    - [Updating the package lock file](#updating-the-package-lock-file)
    - [Creating a symlink to the node_modules folder in a shell session](#creating-a-symlink-to-the-node_modules-folder-in-a-shell-session)
    - [Disabling running NPM install](#disabling-running-npm-install)
- [API documentation](#api-documentation)
- [License](#license)
- [Acknowledgements](#acknowledgements)

<!-- markdown-toc end -->

Prerequisites
=============
To be able to convert Git dependencies, the presence of the `nix-hash`
command-line utility (that is included with the
[Nix package manager](http://nixos/nix)) is required.

Installation
============
There are two ways this package can installed.

To install this package through the Nix package manager, obtain a copy of
[Nixpkgs](http://nixos.org/nixpkgs) and run:

```bash
$ nix-env -f '<nixpkgs>' -iA nodePackages.node2nix
```

Alternatively, this package can also be installed through NPM by running:

```bash
$ npm install -g node2nix
```

Building a development version
==============================
A development version can be deployed by checking out the Git repository and
running:

```bash
$ nix-env -f release.nix -iA package.x86_64-linux
```

The above command installs the development `node2nix` executable into the Nix
profile of the user.

Alternatively, you can the use NPM to install the project dependencies:

```
$ npm install
```

The project only uses JavaScript dependencies and, as such, will also work on
NixOS.

Usage
=====
`node2nix` can be used for a variety of use cases.

Deploying a Node.js development project
---------------------------------------
The primary use case of `node2nix` is to deploy a development project as a NPM
package.

What Node.js developers typically do in a development setting is opening the
source code folder and running:

```bash
$ npm install
```

The above command-line instruction deploys all dependencies declared in the
[`package.json`](https://www.npmjs.org/doc/files/package.json.html) configuration
file so that the application can be run.

With `node2nix` you can use the Nix package manager for exactly the same purpose.
Running the following command generates a collection of Nix expressions from
`package.json`:

```bash
$ node2nix
```

The above command generates three files: `node-packages.nix` capturing the
packages that can be deployed including all its required dependencies,
`node-env.nix` contains the build logic and `default.nix` is a composition
expression allowing users to deploy the package.

By running the following Nix command with these expressions, the project can be
built:

```bash
$ nix-build -A package
```

The above instruction places a `result` symlink in the current working dir
pointing to the build result. An executable (that is part of the project) can be
started as follows:

```bash
$ ./result/bin/node2nix
```

Generating a tarball from a Node.js development project
-------------------------------------------------------
The expressions that are generated by `node2nix` (shown earlier) can also be
used to generate a tarball from the project:

```bash
$ nix-build -A tarball
```

The above command-line instruction produces a tarball that is placed in the
following location:

```bash
$ ls result/tarballs/node2nix-1.0.1.tgz
```

The above tarball can be distributed to any user that has the NPM package
manager installed, and installed by running:

```bash
$ npm install node2nix-1.0.1.tgz
```

Deploying a development environment of a Node.js development project
--------------------------------------------------------------------
Besides deploying a development project, it may also be useful to only install
the project's dependencies and spawning a shell session in which they can be
found.

The following command-line instruction uses the earlier generated expressions
to deploy all the dependencies and opens a development environment:

```bash
$ nix-shell -A shell
```

Within this shell session, files can be modified and run without any hassle.
For example, the following command should work:

```bash
$ node bin/node2nix.js --help
```

Using the Node.js environment in other Nix derivations
--------------------------------------------------------------------
The `node_modules` environment generated by `node2nix` can also be used in
downstream Nix expressions. This can be useful when you want to build a project
that requires running a build system such as Webpack in your Node.js environment.

This environment can be found on the `nodeDependencies` attribute of the
generated output. It contains two important paths: `lib/node_modules` and `bin`.
The former should be copied or symlinked into your build directory, and the
latter should be added to the PATH. (You can also use the `NODE_PATH`
environment variable, but see the warnings about that
[below](#creating-a-symlink-to-the-node_modules-folder-in-a-shell-session).)

Here's an example derivation showing this technique:

```nix
let
  nodeDependencies = (pkgs.callPackage ./my-app {}).nodeDependencies;

in

stdenv.mkDerivation {
  name = "my-webpack-app";
  src = ./my-app;
  buildInputs = [nodejs];
  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"

    # Build the distribution bundle in "dist"
    webpack
    cp -r dist $out/
  '';
}
```

Deploying a collection of NPM packages from the NPM registry
------------------------------------------------------------
The secondary use of `node2nix` is deploying existing NPM packages from the NPM
registry.

Deployment of packages from the registry is driven by a JSON specification that
looks as follows:

```json
[
  "async",
  "underscore",
  "slasp",
  { "mocha" : "1.21.x" },
  { "mocha" : "1.20.x" },
  { "nijs": "0.0.18" },
  { "node2nix": "git://github.com/svanderburg/node2nix.git" }
]
```

The above specification is basically an array of objects. For each element that
is a string, the `latest` version is obtained from the registry.

To obtain a specific version of a package, an object must defined in which the
keys are the name of the packages and the values the versions that must be
obtained.

Any version specification that NPM supports can be used, such as version numbers,
version ranges, HTTP(S) URLs, Git URLs, and GitHub identifiers.

Nix expressions can be generated from this JSON specification as follows:

```bash
$ node2nix -i node-packages.json
```

And by using the generated Nix expressions, we can install `async` with Nix as
follows:

```bash
$ nix-env -f default.nix -iA async
```

For every package for which the latest version has been requested, we can
directly refer to the name of the package to deploy it.

For packages for which a specific version has been specified, we must refer to
it using an attribute that name that is composed of its name and version
specifier.

The following command can be used to deploy the first specific version of `mocha`
declared in the JSON configuration:

```bash
$ nix-env -f default.nix -iA '"mocha-1.21.x"'
```

`node2nix` can be referenced as follows:

```bash
$ nix-env -f default.nix -iA '"node2nix-git://github.com/svanderburg/node2nix.git"'
```

Since every NPM package resolves to a package name and version number we can also
deploy any package by using an attribute consisting of its name and resolved
version number.

This command deploys NiJS version 0.0.18:

```bash
$ nix-env -f default.nix -iA '"nijs-0.0.18"'
```

Using NPM lock files
--------------------
Node.js 8.x and higher (that includes npm 5.x or higher) can also work with
so-called *lock files* that pinpoint the exact versions used of all dependencies
and transitive dependencies, and provides a content addressable cache to speed
up deployments.

Some Node.js development projects may include a `package-lock.json` file
pinpointing the exact versions of the dependencies and transitive dependencies.
`node2nix` can use this file to generate a Nix expression from it so that Nix
uses the exact same packages:

```bash
$ node2nix -l package-lock.json
```

Generating packages for specific Node.js versions
-------------------------------------------------
By default, `node2nix` generates Nix expressions that should be used in
conjuction with Node.js 12.x, which is currently the oldest supported LTS
release.

When it is desired, it is also possible to generate expressions for other
Node.js versions. For example, Node.js 4.x does not use a
flattening/deduplication algorithm, and 6.x that does not support lock files or
caching.

The old non-flattening structure can be simulated by adding the `--no-flatten`
parameter.

Additionally, to enable all flags to make generation for a certain Node.js
work, `node2nix` provides convenience parameters. For example, by using the `-4`
parameter, we can generate expressions that can be used with Node.js 4.x:

```bash
$ node2nix -4 -i node-package.json
```

By running the following command, Nix deploys NiJS version 0.0.18 using Node.js
4.x and npm 2.x:

```bash
$ nix-env -f default.nix -iA '"nijs-0.0.18"'
```

Advanced options
================
`node2nix` also has a number of advanced options.

Development mode
----------------
By default, NPM packages are deployed in production mode, meaning that the
development dependencies are not installed by default. By adding the
`--development` command line option, you can also deploy the development
dependencies:

```bash
$ node2nix --development
```

Specifying paths
----------------
If no options are specified, `node2nix` makes implicit assumptions on the
filenames of the input JSON specification and the output Nix expressions. These
filenames can be modified with command-line options:

```bash
$ node2nix --input package.json --output registry.nix --composition default.nix --node-env node-env.nix
```

Using alternative NPM registries
--------------------------------
You can also use an alternative NPM registry (such as a private one), by adding
the `--registry` option:

```bash
$ node2nix -i node-packages.json --registry http://private.registry.local
```

Adding unspecified dependencies
-------------------------------
A few exotic NPM packages may have dependencies on native libraries that reside
somewhere on the user's host system. Unfortunately, NPM's metadata does not
specify them, and as a consequence, it may result in failing Nix builds due to
missing dependencies.

As a solution, the generated expressions by `node2nix` are made overridable. The
override mechanism can be used to manually inject additional unspecified
dependencies.

The easiest way to do this is to create a wrapper Nix expression that imports
the generated composition expression from `node2nix` and injects additional
dependencies.

Consider the following package collection file (named: `node-packages.json`)
that installs one NPM package named `floomatic`:

```json
[
  "floomatic"
]
```

We can generate Nix expressions from the above specification, by running:

```bash
$ node2nix -i node-packages.json
```

One of floomatic's dependencies is an NPM package named `native-diff-match-patch`
that requires the Qt 4.x library and pkgconfig, which are native dependencies not
detected by the `node2nix` generator.

With the following wrapper expression (named: `override.nix`), we can inject
these dependencies ourselves:

```nix
{pkgs ? import <nixpkgs> {
    inherit system;
}, system ? builtins.currentSystem}:

let
  nodePackages = import ./default.nix {
    inherit pkgs system;
  };
in
nodePackages // {
  floomatic = nodePackages.floomatic.override {
    buildInputs = [ pkgs.pkgconfig pkgs.qt4 ];
  };
}
```

The expression does the following:

* We import the composition expression (`default.nix`) generated by `node2nix`.
* We take the old derivation that builds the `floomatic` package, and we add the
  missing native dependencies as build inputs by defining an override.

With the above wrapper expression, we can correctly deploy floomatic, by running:

```bash
$ nix-build override.nix -A floomatic
```

Wrapping or patching the code or any of its dependencies
--------------------------------------------------------
Some packages or any of its dependencies may also require some ad-hoc fixes to
make them work. In such cases, we can implement a `preRebuild` hook with shell
instructions that will be executed before the builder will run `npm rebuild` and
`npm install`.

For example, consider the `dnschain` package:

```json
[
  "dnschain"
]
```

We can generate Nix expressions from the above specification, by running:

```bash
$ node2nix -i node-packages.json
```

`dnschain` has a practical problem -- it requires OpenSSL to be in the `PATH` of
the user. We can create an `override.nix` expression implementing a `preRebuild`
hook that wraps the executable in a script that adds `openssl` to the `PATH`:

```nix
{pkgs ? import <nixpkgs> {
  inherit system;
}, system ? builtins.currentSystem}:

let
  nodePackages = import ./default.nix {
    inherit pkgs system;
  };
in
nodePackages // {
  dnschain = nodePackages.floomatic.override {
    preRebuild = ''
      wrapProgram $out/bin/dnschain --suffix PATH : ${pkgs.openssl.bin}/bin
    '';
  };
}
```

With the above wrapper expression, we can deploy a wrapped `dnschain` (that is
able to find the `openssl` executable), by running:

```bash
$ nix-build override.nix -A dnschain
```

Adding additional/global NPM packages to a packaging process
------------------------------------------------------------
Sometimes it may also be required to supplement a packaging process with
additional NPM packages. For example, when building certain NPM projects, some
dependencies have to be installed globally.

A prominent example of such a workflow is a [Grunt](http://gruntjs.com) project.
The grunt CLI is typically installed globally, whereas its plugins are installed
as development dependencies.

We can automate such a workflow as follows. Consider the following
`package.json` example:

```json
{
  "name": "grunt-test",
  "version": "0.0.1",
  "private": "true",
  "devDependencies": {
    "grunt": "*",
    "grunt-contrib-jshint": "*",
    "grunt-contrib-watch": "*"
  }
}
```

The above configuration declares grunt and two grunt plugins (`jshint` and
`watch`) as development dependencies.

We can create a supplemental package specification that refers to additional
NPM packages that are supposed to be installed globally:

```json
[
  "grunt-cli"
]
```

The above configuration (`supplement.json`) states that we need the `grunt-cli`
as an additional package, installed globally.

Furtheremore, you can provide specific versions of supplemental packages.
Here is example of `supplement.json` with `grunt-cli` version `1.2.0`:

```json
[
  {
    "grunt-cli": "1.2.0"
  }
]
```

Running the following command-line instruction generates the Nix expressions for
the project:

```bash
$ node2nix -d -i package.json --supplement-input supplement.json
```

By overriding the generated expressions, we can instruct the builder to execute
`grunt` after the dependencies have been deployed:

```nix
{ pkgs ? import <nixpkgs> {}
, system ? builtins.currentSystem
}:

let
  nodePackages = import ./default.nix {
    inherit pkgs system;
  };
in
nodePackages // {
  package = nodePackages.package.override {
    postInstall = "grunt";
  };
}
```

The above expression (`override.nix`) defines a `postInstall` hook that executes
grunt after the NPM package has been deployed.

Running the following command executes the packaging process, including the
grunt post-processing step:

```bash
$ nix-build override.nix -A package
```

Using private Git repositories
------------------------------
In some development projects, it may be desired to deploy private Git
repositories as dependencies. The `fetchgit {}` function in Nixpkgs, however,
only supports public repositories.

It is also possible to instruct the generator to use the `fetchgitPrivate {}`
function, that adds support for private repositories that can be reached with
SSH:

```bash
$ node2nix --use-fetchgit-private
```

Before running the `node2nix` command shown above, you probably want to set
up `ssh-agent` first and use `ssh-add` to add a private key to the keychain to
prevent the generator from asking for passphrases.

When deploying a project or package, you need to pass an additional parameter
that provides an SSH configuration file with a reference to an identify file.
The following SSH config file (e.g. `~/ssh_config`) suffices for me:

```
StrictHostKeyChecking=no
UserKnownHostsFile /dev/null
IdentityFile ~/id_rsa
```

When deploying a package with Nix, you must propagate the location of the SSH
config file as a parameter:

```bash
$ nix-build -A package -I ssh-config-file=~/ssh_config
```

It is also possible to provide the location of the config file by adapting the
`NIX_PATH` environment variable, as opposed to using the `-I` parameter:

```bash
$ export NIX_PATH=ssh-config-file=~/ssh_config:$NIX_PATH
```

The above approach also makes it possible to deploy a NPM package with private
dependencies as part of a NixOS, NixOps or Disnix configuration.

Disable cache bypassing
-----------------------
In a Nix builder environment, the NPM packages cache is empty and NPM does not
seem to trust dependencies that are already stored in the bundled
`node_modules/` folder, because they lack the meta data that can be used for
integrity checks.

By default, `node2nix` bypasses the cache by augmenting package configuration
files with these mandatory meta data fields.

If older versions of NPM are used (any version before 5.x), this meta
information is not required. Bypassing the cache can be disabled by providing
the `--no-bypass-cache` parameter.

Troubleshooting
===============
This section contains some troubleshooting information for common problems.

Deploying peer dependencies
---------------------------
In NPM version 2.x and older, peer dependencies were automatically deployed if
they were not declared as regular dependencies. In newer versions of NPM, this
behaviour has changed -- peer dependencies are only used for version checks,
but NPM no longer installs them.

Some package deployments may still rely on the old behaviour and will fail to
deploy. To generate expressions that install peer dependencies, you can add the
`--include-peer-dependencies` parameter:

```bash
$ node2nix --include-peer-dependencies
```

Stripping optional dependencies
-------------------------------
When NPM packages with optional dependencies are published to the NPM registry,
the optional dependencies become regular runtime dependencies. As a result,
when deploying a package with a broken "integrated" optional dependency, the
deployment with fail, unlike pure optional dependencies that are allowed to
fail.

To fix these package deployments, it is possible to strip the optional
dependencies from packages installed from the NPM registry:

```bash
$ node2nix --strip-optional-dependencies
```

Updating the package lock file
------------------------------
When deploying projects that provide a `package-lock.json` file, `node2nix`
deployments will typically fail if the corresponding `package.json`
configuration has changed after the generation of the lock file, because the
dependency tree in the lock file may be incomplete.

To fix this problem, `npm install` must be executed again so that the missing
or changed dependencies are updated in the lock file.

Creating a symlink to the node_modules folder in a shell session
----------------------------------------------------------------
In Nix shell sessions, that can be started with `nix-shell -A shell`,
conventional Node.js projects will typically work, because there is a
`NODE_PATH` environment variable that refers to a Nix store path that provides
all the dependencies that the project needs.

However, there are also a variety of Node.js/NPM-based build tools available,
such as Grunt, Gulp, Babel or ESLint, that work with *plugins* that are stored
in the `node_modules/` folder of the project.

Unfortunately, these tools do not respect the `NODE_PATH` environment variable
and, as a result, fail to work in a Nix shell session.

As a workaround, you can create a symlink in the project's root folder to allow
these tools to find their dependencies:

```bash
$ ln -s $NODE_PATH node_modules
```

Keep in mind that the symlink needs to be removed again if you want to deploy
the package with `nix-build` or `nix-env`.

Disabling running NPM install
-----------------------------
`node2nix` tries to mimic NPM's dependency resolver as closely as possible.
However, it may happen that there is a small difference and the deployment fails
a result.

A mismatch is typically caused by versions that can't be reliably resolved (e.g.
due to wildcards) or errors in lifting bundled dependencies. In many cases, the
package should still work despite the error.

To prevent the deployment from failing, we can disable the `npm install` step,
by overriding the package:

```nix
{pkgs ? import <nixpkgs> {
  inherit system;
}, system ? builtins.currentSystem}:

let
  nodePackages = import ./default.nix {
    inherit pkgs system;
  };
in
nodePackages // {
  express = nodePackages.express.override {
    dontNpmInstall = true;
  };
}
```

By overriding a package and setting the `dontNpmInstall` parameter to `true`, we
skip the install step (which merely serves as a check). The generated expression
is actually responsible for obtaining and extracting the dependencies.

API documentation
=================
This package includes API documentation, which can be generated with
[JSDoc](http://usejsdoc.org).

License
=======
The contents of this package is available under the
[MIT license](http://opensource.org/licenses/MIT)

Acknowledgements
================
This package is based on ideas and principles pioneered in
[npm2nix](http://github.com/NixOS/npm2nix).
