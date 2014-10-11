{ nixpkgs ? <nixpkgs>
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  version = builtins.readFile ./version;
  pkgs = import nixpkgs {};
in
rec {
  tarball = (import ./default.nix {
    inherit pkgs;
    system = builtins.currentSystem;
  }).tarball;
  
  build = pkgs.stdenv.lib.genAttrs systems (system:
    (import ./default.nix {
      pkgs = import nixpkgs { inherit system; };
      inherit system;
    }).build
  );
  
  doc = pkgs.stdenv.mkDerivation {
    name = "nijs-docs-${version}";
    src = "${tarball}/tarballs/npm2nix-${version}.tgz";
    
    buildInputs = [ pkgs.rubyLibs.jsduck ];
    buildPhase = "make duck";
    installPhase = ''
      mkdir -p $out/nix-support
      cp -R build/* $out
      echo "doc api $out" >> $out/nix-support/hydra-build-products
    '';
  };
}
