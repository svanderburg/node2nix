npm2nix
=======

Generate nix expressions from npmjs.org!


Usage
-----

`npm2nix -i node-packages.json -o node-packages.generated.nix`


JSON structure
--------------

npm2nix expects the passed JSON file to be a list of strings and at most one
object. Strings are taken as the name of the package. The object must be
a valid dependencies object for an for an npm `packages.json` file.
Alternatively, the passed JSON file can be an npm `package.json`, in which
case the expressions for its dependencies will be generated.
