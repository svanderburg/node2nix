#!/bin/sh -e

# This script generates the Nix expressions for node2nix itself and its
# testcases.
# It can be invoked by installing its dependencies first, by either running:
#
# $ npm install
#
# or by starting a Nix shell:
#
# $ nix-shell -A shell

node bin/node2nix -e nix/node-env.nix --no-copy-node-env
cd tests
node ../bin/node2nix -i tests.json -o node-packages-v4.nix -c default-v4.nix -e ../nix/node-env.nix --no-copy-node-env
node ../bin/node2nix -i tests.json -o node-packages-v6.nix -c default-v6.nix -e ../nix/node-env.nix -6 --no-copy-node-env
cd grunt
node ../../bin/node2nix -d -i package.json --supplement-input supplement.json -e ../../nix/node-env.nix --no-copy-node-env
