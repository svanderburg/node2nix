{ nixpkgs ? <nixpkgs>
, systems ? [ "i686-linux" "x86_64-linux" "x86_64-darwin" ]
}:

let
  pkgs = import nixpkgs {};
  jobset = import ./default.nix {
    inherit pkgs;
    system = builtins.currentSystem;
  };
in
{
  inherit (jobset) tarball;
  
  package = pkgs.lib.genAttrs systems (system:
    (import ./default.nix {
      pkgs = import nixpkgs { inherit system; };
      inherit system;
    }).package
  );
  
  tests = pkgs.lib.genAttrs systems (system:
    {
      v4 = import ./tests/default-v4.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
      v5 = import ./tests/default-v5.nix {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      };
    });
}
