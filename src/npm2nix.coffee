generatePackage = require './generate-package'

name = process.argv[2]
range = process.argv[3] ? "*"
generatePackage name, range, (packages) ->
  printPackage = (pkg, name, range) ->
    console.log """
      #{}  "#{name} = self."#{name}-#{range}";
        "#{name}-#{range}" = self.buildNodePackage rec {
          name = "#{name}-#{pkg.version}";
          src = #{if pkg.patchLatest then 'self.patchLatest' else 'fetchurl' } {
            url = "http://registry.npmjs.org/#{name}/-/${name}.tgz";
            sha256 = "#{pkg.hash.toString 'hex'}";
          };
          deps = [
      #{("      self.\"#{dep}#{if ver is "*" then "" else "-#{ver}"}\"" for dep, ver of pkg.dependencies).join "\n"}
          ];
        };

    """
    for dep, ver of pkg.dependencies
      printPackage packages["#{dep}-#{ver}"], dep, ver
  printPackage packages["#{name}-#{range}"], name, range
