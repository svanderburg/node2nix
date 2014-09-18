#!/usr/bin/env node

var optparse = require('optparse');
var npm2nix = require('../lib/npm2nix.js');

/* Define command-line options */

var switches = [
    ['-h', '--help', 'Shows help sections'],
    ['-i', '--input FILE', 'Specifies a path to a JSON file containing an object with package settings or an array of dependencies'],
    ['-o', '--output FILE', 'A Nix expression representing a registry of Node.js packages'],
    ['-d', '--development', 'Specifies whether to do a development deployment for a package.json deployment (false by default)']
];

var parser = new optparse.OptionParser(switches);

/* Set some variables and their default values */

var help = false;
var production = true;
var inputJSON = null;
var outputNix = null;
var executable;

/* Define process rules for option parameters */

parser.on('help', function(arg, value) {
    help = true;
});

parser.on('input', function(arg, value) {
    inputJSON = value;
});

parser.on('output', function(arg, value) {
    outputNix = value;
});

parser.on('development', function(arg, value) {
    production = false;
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

    process.stdout.write("Usage:\n\n");
    process.stdout.write(executable + " [options] -i package.json -o output.nix\n\n");
    process.stdout.write("Options:\n\n");
    
    var maxlen = 20;
    
    for(var i = 0; i < switches.length; i++) {
    
        var currentSwitch = switches[i];
        
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

/* Verify the input parameters */

if(!inputJSON) {
    process.stderr.write("No input JSON file is provided!\n");
    process.exit(1);
}

if(!outputNix) {
    process.stderr.write("No output Nix expression file is provided!\n");
    process.exit(1);
}

/* Perform the NPM to Nix conversion */
npm2nix.npmToNix(inputJSON, outputNix, production, function(err) {
    if(err) {
        process.stderr.write(err + "\n");
        process.exit(1);
    } else {
        process.exit(0);
    }
});