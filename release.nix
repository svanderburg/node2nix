{ nixpkgs ? <nixpkgs>
, systems ? [ "i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ]
}:

let
  pkgs = import nixpkgs {};

  version = (builtins.fromJSON (builtins.readFile ./package.json)).version;

  jobset = import ./default.nix {
    inherit pkgs;
    system = builtins.currentSystem;
  };
in
rec {
  inherit (jobset) tarball;

  package = pkgs.lib.genAttrs systems (system:
    (import ./default.nix {
      pkgs = import nixpkgs { inherit system; };
      inherit system;
    }).package.override {
      postInstall = ''
      mkdir -p $out/share/doc/node2nix
      $out/lib/node_modules/node2nix/node_modules/jsdoc/jsdoc.js -R README.md -r lib -d $out/share/doc/node2nix/apidox
      mkdir -p $out/nix-support
      echo "doc api $out/share/doc/node2nix/apidox" >> $out/nix-support/hydra-build-products
    '';
    }
  );

  tests = pkgs.lib.genAttrs systems (system:
    {
      v10 = import ./tests/override-v10.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      v12 = import ./tests/override-v12.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      v14 = import ./tests/override-v14.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      grunt = import ./tests/grunt/override.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      lockfile = (import ./tests/lockfile {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      }).package;
      lockfile-v2 = (import ./tests/lockfile-v2 {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      }).package;
      scoped = (import ./tests/scoped {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      }).package;
    }) // {
      cli = import ./tests/cli {
        inherit nixpkgs;
        node2nix = builtins.getAttr (builtins.currentSystem) package;
      };
    };

  release = pkgs.releaseTools.aggregate {
    name = "node2nix-${version}";
    constituents = [
      tarball
    ]
    ++ map (system: builtins.getAttr system package) systems
    ++ pkgs.lib.flatten (map (system:
      let
        tests_ = tests."${system}".v14;
      in
      map (name: builtins.getAttr name tests_) (builtins.attrNames tests_)
      ) systems)
    ++ map (system: tests."${system}".grunt) systems
    ++ map (system: tests."${system}".lockfile) systems
    ++ map (system: tests."${system}".scoped) systems
    ++ [ tests.cli ];
  };
}
