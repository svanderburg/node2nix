{ nixpkgs ? <nixpkgs>
, systems ? [ "i686-linux" "x86_64-linux" "x86_64-darwin" ]
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
    }).package
  );

  tests = pkgs.lib.genAttrs systems (system:
    {
      v4 = import ./tests/override-v4.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      v5 = import ./tests/override-v5.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      v6 = import ./tests/override-v6.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      grunt = import ./tests/grunt/override.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
    });

  release = pkgs.releaseTools.aggregate {
    name = "node2nix-${version}";
    constituents = [
      tarball
    ]
    ++ map (system: builtins.getAttr system package) systems
    ++ pkgs.lib.flatten (map (system:
      let
        tests_ = tests."${system}".v4;
      in
      map (name: builtins.getAttr name tests_) (builtins.attrNames tests_)
      ) systems)
    ++ pkgs.lib.flatten (map (system:
      let
        tests_ = tests."${system}".v5;
      in
      map (name: builtins.getAttr name tests_) (builtins.attrNames tests_)
      ) systems)
    ++ pkgs.lib.flatten (map (system:
      let
        tests_ = tests."${system}".v6;
      in
      map (name: builtins.getAttr name tests_) (builtins.attrNames tests_)
      ) systems)
    ++ map (system: tests."${system}".grunt) systems;
  };
}
