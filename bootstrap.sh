#!/bin/sh -e

# This script generates the Nix expressions for npm2nix itself and its
# testcases.
# It can be invoked by installing its dependencies first, by either running:
#
# $ npm install
#
# or by starting a Nix shell:
#
# $ nix-shell -A shell

node bin/npm2nix -e nix/node-env.nix
cd tests
node ../bin/npm2nix -i tests.json -o node-packages-v4.nix -c default-v4.nix -e ../nix/node-env.nix
node ../bin/npm2nix -i tests.json -o node-packages-v5.nix -c default-v5.nix -e ../nix/node-env.nix -5
