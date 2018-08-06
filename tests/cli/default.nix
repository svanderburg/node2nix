{nixpkgs, node2nix}:

let
  testprojects = ./testprojects;
in
with import "${nixpkgs}/nixos/lib/testing.nix" { system = builtins.currentSystem; };

simpleTest {
  nodes = {
    machine = {pkgs, ...}:

    {
      environment.systemPackages = [ node2nix ];
    };
  };
  testScript =
    ''
      startAll;

      $machine->mustSucceed("cp -av ${testprojects} testprojects");
      $machine->mustSucceed("chmod u+w testprojects");

      # Try to generate Nix expressions for a package.json with no name. This should fail.
      $machine->mustFail("cd testprojects/noname; node2nix");

      # Try to generate Nix expressions for a package.json with no version. This should fail.
      $machine->mustFail("cd testprojects/noversion; node2nix");

      # Try to generate Nix expressions for a package.json with a name and version. This should succeed.
      $machine->mustSucceed("cd testprojects/complete; node2nix");

      # Try to generate Nix expression from package.json without specifying the lock file. This should raise a warning.
      my $output = $machine->mustSucceed("cd testprojects/lock; node2nix -8");
      if($output =~ /lock file exists/) {
          print "Lock file warning raised\n";
      } else {
          die "A lock file warning should be raised";
      }

      # Try to generate Nix expression in a project that has a node_modules/ sub folder. This should raise a warning.
      $output = $machine->mustSucceed("cd testprojects/garbage; node2nix");

      if($output =~ /node_modules\/ folder in the root directory/) {
          print "node_modules/ warning raised\n";
      } else {
          die "A node_modules/ warning should be raised";
      }
    '';
}
