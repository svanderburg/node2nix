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

PROJECT=`dirname ${BASH_SOURCE[0]-$0}`

node $PROJECT/bin/node2nix \
  -e $PROJECT/nix/node-env.nix \
  -6 \
  -d \
  --no-copy-node-env

# tests

node $PROJECT/bin/node2nix \
  -i $PROJECT/tests/tests.json \
  -o $PROJECT/tests/node-packages-v4.nix \
  -c $PROJECT/tests/default-v4.nix \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env

node $PROJECT/bin/node2nix \
  -i $PROJECT/tests/tests.json \
  -o $PROJECT/tests/node-packages-v6.nix \
  -c $PROJECT/tests/default-v6.nix \
  -e $PROJECT/nix/node-env.nix \
  -6 \
  --no-copy-node-env

node $PROJECT/bin/node2nix \
  -i $PROJECT/tests/tests.json \
  -o $PROJECT/tests/node-packages-v8.nix \
  -c $PROJECT/tests/default-v8.nix \
  -e $PROJECT/nix/node-env.nix \
  -8 \
  --no-copy-node-env

node $PROJECT/bin/node2nix \
  -i $PROJECT/tests/tests.json \
  -o $PROJECT/tests/node-packages-v10.nix \
  -c $PROJECT/tests/default-v10.nix \
  -e $PROJECT/nix/node-env.nix \
  --nodejs-10 \
  --no-copy-node-env

# grunt
node $PROJECT/bin/node2nix \
  -d \
  -i $PROJECT/tests/grunt/package.json \
  -o $PROJECT/tests/grunt/node-packages.nix \
  -c $PROJECT/tests/grunt/default.nix \
  --supplement-input $PROJECT/tests/grunt/supplement.json \
  --supplement-output $PROJECT/tests/grunt/supplement.nix \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env

# lockfile
node $PROJECT/bin/node2nix \
  -8 \
  -i $PROJECT/tests/lockfile/package.json \
  -l $PROJECT/tests/lockfile/package-lock.json \
  -o $PROJECT/tests/lockfile/node-packages.nix \
  -c $PROJECT/tests/lockfile/default.nix \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env

# scoped_package
node $PROJECT/bin/node2nix \
  -8 \
  -i $PROJECT/tests/scoped_package/package.json \
  -o $PROJECT/tests/scoped_package/node-packages.nix \
  -c $PROJECT/tests/scoped_package/default.nix \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env
