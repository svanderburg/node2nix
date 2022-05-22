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

node bin/node2nix -e nix/node-env.nix --nodejs-14 -d --no-copy-node-env
cd tests
node ../bin/node2nix -i tests.json -o node-packages-v14.nix -c default-v14.nix -e ../nix/node-env.nix --nodejs-14 --no-copy-node-env
node ../bin/node2nix -i tests.json -o node-packages-v16.nix -c default-v16.nix -e ../nix/node-env.nix --nodejs-16 --no-copy-node-env
cd grunt
node ../../bin/node2nix -d -i package.json --supplement-input supplement.json -e ../../nix/node-env.nix --no-copy-node-env
cd ../lockfile
node ../../bin/node2nix -l package-lock.json -e ../../nix/node-env.nix --no-copy-node-env
cd ../lockfile-v2
node ../../bin/node2nix -l package-lock.json -e ../../nix/node-env.nix --no-copy-node-env
cd ../scoped
node ../../bin/node2nix -e ../../nix/node-env.nix --no-copy-node-env
cd ../versionless
node ../../bin/node2nix -e ../../nix/node-env.nix --no-copy-node-env
