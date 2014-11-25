{system ? builtins.currentSystem, pkgs ? import <nixpkgs> {
    inherit system;
  }, overrides ? {}}:

let
  nodeEnv = import ./nix/node-env.nix {
    inherit (pkgs) stdenv fetchurl nodejs python utillinux runCommand;
  };
  registry = (import ./registry.nix {
    inherit (nodeEnv) buildNodePackage;
    inherit (pkgs) fetchurl fetchgit;
    self = registry;
  }) // overrides;
in
{
  inherit registry;
  tarball = nodeEnv.buildNodeSourceDist {
    name = "npm2nix";
    version = "6.0.0";
    src = ./.;
  };
  build = registry."npm2nix-6.0.0" {};
}