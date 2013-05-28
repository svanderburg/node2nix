npm2nix
=======
Generate nix expressions to build npm packages!

Usage
-----
`npm2nix node-packages.json > node-packages.generated.nix`

JSON structure
--------------
npm2nix expects the passed JSON file to be a list of objects. Each object must contain a `name` key (e.g. `coffee-script`) and may optionally contain a `range` key formatted in a way understood by [semver](https://github.com/isaacs/node-semver) (e.g. `~1.2.4`)
