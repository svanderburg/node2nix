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

PROJECT=$(readlink -f $0 | xargs dirname)

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
cd $PROJECT/tests/grunt

node $PROJECT/bin/node2nix \
  -d \
  -i ./package.json \
  --supplement-input ./supplement.json \
  --supplement-output ./supplement.nix \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env

# lockfile
cd $PROJECT/tests/lockfile

node $PROJECT/bin/node2nix \
  -8 \
  -i ./package.json \
  -l ./package-lock.json \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env

# scoped_package
cd $PROJECT/tests/scoped_package

node $PROJECT/bin/node2nix \
  -8 \
  -i ./package.json \
  -o ./node-packages.nix \
  -c ./default.nix \
  -e $PROJECT/nix/node-env.nix \
  --no-copy-node-env
