{pkgs ? import <nixpkgs> {
    inherit system;
}, system ? builtins.currentSystem}:

let
  nodePackages = import ./default-v6.nix {
    inherit pkgs system;
  };
in
nodePackages // {
  floomatic = nodePackages.floomatic.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.pkgconfig pkgs.qt4 ];
  });
}
