{nixpkgs, node2nix}:

let
  testprojects = ./testprojects;
in
with import "${nixpkgs}/nixos/lib/testing-python.nix" { system = builtins.currentSystem; };

simpleTest {
  nodes = {
    machine = {pkgs, ...}:

    {
      environment.systemPackages = [ node2nix ];
    };
  };
  testScript =
    ''
      start_all()

      machine.succeed(
          "cp -av ${testprojects} testprojects"
      )
      machine.succeed("chmod u+w testprojects")

      # Try to generate Nix expressions for a package.json with no name. This should fail.
      machine.fail("cd testprojects/noname; node2nix")

      # Try to generate Nix expressions for a package.json with no version. This should fail.
      machine.fail("cd testprojects/noversion; node2nix")

      # Try to generate Nix expressions for a package.json with a name and version. This should succeed.
      machine.succeed("cd testprojects/complete; node2nix")

      # Try to generate Nix expression from package.json without specifying the lock file. This should raise a warning.
      output = machine.succeed("cd testprojects/lock; node2nix -8")
      if "lock file exists" in output:
          print("Lock file warning raised")
      else:
          raise Exception("A lock file warning should be raised")

      # Try to generate Nix expression in a project that has a node_modules/ sub folder. This should raise a warning.
      output = machine.succeed("cd testprojects/garbage; node2nix")

      if "node_modules/ folder in the root directory":
          print("node_modules/ warning raised")
      else:
          raise Exception("A node_modules/ warning should be raised")
    '';
}
