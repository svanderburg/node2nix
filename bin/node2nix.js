#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var optparse = require('optparse');
var node2nix = require('../lib/node2nix.js');

/* Define command-line options */

var switches = [
    ['-h', '--help', 'Shows help sections'],
    ['-v', '--version', 'Shows version'],
    ['-i', '--input FILE', 'Specifies a path to a JSON file containing an object with package settings or an array of dependencies (defaults to: package.json)'],
    ['-o', '--output FILE', 'Path to a Nix expression representing a registry of Node.js packages (defaults to: node-packages.nix)'],
    ['-c', '--composition FILE', 'Path to a Nix composition expression allowing someone to deploy the generated Nix packages from the command-line (defaults to: default.nix)'],
    ['-e', '--node-env FILE', 'Path to the Nix expression implementing functions that builds NPM packages (defaults to: node-env.nix)'],
    ['-l', '--lock FILE', 'Path to the package-lock.json file that pinpoints the variants of all dependencies'],
    ['-d', '--development', 'Specifies whether to do a development (non-production) deployment for a package.json deployment (false by default)'],
    ['-6', '--nodejs-6', 'Provides all settings to generate expression for usage with Node.js 6.x (default is: Node.js 4.x)'],
    ['-8', '--nodejs-8', 'Provides all settings to generate expression for usage with Node.js 8.x (default is: Node.js 4.x)'],
    ['--supplement-input FILE', 'A supplement package JSON file that are passed as build inputs to all packages defined in the input JSON file'],
    ['--supplement-output FILE', 'Path to a Nix expression representing a supplementing set of Nix packages provided as inputs to a project (defaults to: supplement.nix)'],
    ['--include-peer-dependencies', 'Specifies whether to include peer dependencies. In npm 2.x, this is the default. (false by default)'],
    ['--flatten', 'Simulate npm 3.x flat dependency structure. (false by default)'],
    ['--pkg-name NAME', 'Specifies the name of the Node.js package to use from Nixpkgs (defaults to: nodejs)'],
    ['--registry NAME', 'URL referring to the NPM packages registry. It defaults to the official NPM one, but can be overridden to support private registries'],
    ['--bypass-cache', 'Specifies that package builds need to bypass the content addressable cache (required for NPM 5.x)'],
    ['--no-copy-node-env', 'Do not create a copy of the Nix expression that builds NPM packages']
];

var parser = new optparse.OptionParser(switches);

/* Set some variables and their default values */

var help = false;
var version = false;
var production = true;
var includePeerDependencies = false;
var flatten = false;
var inputJSON = "package.json";
var outputNix = "node-packages.nix";
var compositionNix = "default.nix";
var supplementJSON;
var supplementNix = "supplement.nix";
var nodeEnvNix = "node-env.nix";
var lockJSON;
var registryURL = "http://registry.npmjs.org";
var nodePackage = "nodejs-4_x";
var noCopyNodeEnv = false;
var bypassCache = false;
var executable;

/* Define process rules for option parameters */

parser.on('help', function(arg, value) {
    help = true;
});

parser.on('version', function(arg, value) {
    version = true;
});

parser.on('input', function(arg, value) {
    inputJSON = value;
});

parser.on('output', function(arg, value) {
    outputNix = value;
});

parser.on('composition', function(arg, value) {
    compositionNix = value;
});

parser.on('supplement-input', function(arg, value) {
    supplementJSON = value;
});

parser.on('supplement-output', function(arg, value) {
    supplementNix = value;
});

parser.on('node-env', function(arg, value) {
    nodeEnvNix = value;
});

parser.on('lock', function(arg, value) {
    if(value) {
        lockJSON = value;
    } else {
        lockJSON = "package-lock.json";
    }
});

parser.on('development', function(arg, value) {
    production = false;
});

parser.on('nodejs-6', function(arg, value) {
    flatten = true;
    nodePackage = "nodejs-6_x";
});

parser.on('nodejs-8', function(arg, value) {
    flatten = true;
    nodePackage = "nodejs-8_x";
    bypassCache = true;
});

parser.on('include-peer-dependencies', function(arg, value) {
    includePeerDependencies = true;
});

parser.on('flatten', function(arg, value) {
    flatten = true;
});

parser.on('pkg-name', function(arg, value) {
    nodePackage = value;
});

parser.on('registry', function(arg, value) {
    registryURL = value;
});

parser.on('bypass-cache', function(arg, value) {
    bypassCache = true;
});

parser.on('no-copy-node-env', function(arg, value) {
    noCopyNodeEnv = true;
});

/* Define process rules for non-option parameters */

parser.on(1, function(opt) {
    executable = opt;
});

/* Do the actual command-line parsing */

parser.parse(process.argv);

/* Display the help, if it has been requested */

if(help) {
    function displayTab(len, maxlen) {
        for(var i = 0; i < maxlen - len; i++) {
            process.stdout.write(" ");
        }
    }

    process.stdout.write("Usage: " + executable + " [OPTION]\n\n");

    process.stdout.write("Generates a set of Nix expressions from a NPM package's package.json\n");
    process.stdout.write("configuration or a collection.json configuration containing a set of NPM\n");
    process.stdout.write("dependency specifiers so that the packages can be deployed with Nix instead\n");
    process.stdout.write("of NPM.\n\n");

    process.stdout.write("Options:\n");

    var maxlen = 30;

    for(var i = 0; i < switches.length; i++) {

        var currentSwitch = switches[i];

        process.stdout.write("  ");

        if(currentSwitch.length == 3) {
            process.stdout.write(currentSwitch[0] + ", "+currentSwitch[1]);
            displayTab(currentSwitch[0].length + 2 + currentSwitch[1].length, maxlen);
            process.stdout.write(currentSwitch[2]);
        } else {
            process.stdout.write(currentSwitch[0]);
            displayTab(currentSwitch[0].length, maxlen);
            process.stdout.write(currentSwitch[1]);
        }

        process.stdout.write("\n");
    }

    process.exit(0);
}

/* Display the version, if it has been requested */

if(version) {
    var version = JSON.parse(fs.readFileSync(path.join(__dirname, "..", "package.json"))).version;

    process.stdout.write("node2nix " + version + "\n");
    process.exit(0);
}

/* Perform the NPM to Nix conversion */
node2nix.npmToNix(inputJSON, outputNix, compositionNix, nodeEnvNix, lockJSON, supplementJSON, supplementNix, production, includePeerDependencies, flatten, nodePackage, registryURL, noCopyNodeEnv, bypassCache, function(err) {
    if(err) {
        process.stderr.write(err + "\n");
        process.exit(1);
    } else {
        process.exit(0);
    }
});
