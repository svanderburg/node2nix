{ pkgs ? import <nixpkgs> {}
, system ? builtins.currentSystem
}:

let
  nodePackages = import ./default.nix {
    inherit pkgs system;
  };
in
nodePackages.package.override {
  postInstall = "grunt";
}
