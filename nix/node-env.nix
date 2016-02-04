{stdenv, python, nodejs, utillinux, runCommand}:

let
  # Function that generates a TGZ file from a NPM project
  buildNodeSourceDist =
    { name, version, src }:
    
    stdenv.mkDerivation {
      name = "node-tarball-${name}-${version}";
      inherit src;
      buildInputs = [ nodejs ];
      buildPhase = ''
        export HOME=$TMPDIR
        tgzFile=$(npm pack)
      '';
      installPhase = ''
        mkdir -p $out/tarballs
        mv $tgzFile $out/tarballs
        mkdir -p $out/nix-support
        echo "file source-dist $out/tarballs/$tgzFile" >> $out/nix-support/hydra-build-products
      '';
    };

  includeDependencies = {dependencies}:
    stdenv.lib.optionalString (dependencies != [])
      (stdenv.lib.concatMapStrings (dependency:
        ''
          # Bundle the dependencies of the package
          mkdir -p node_modules
          cd node_modules
          
          # Only include dependencies if they don't exist. They may also be bundled in the package.
          if [ ! -e "${dependency.name}" ]
          then
              ${composePackage dependency}
          fi
          
          cd ..
        ''
      ) dependencies);

  # Recursively composes the dependencies of a package
  composePackage = { name, src, dependencies ? [], ... }@args:
    ''
      unpackFile ${src}

      if [ "$strippedName" != "${name}" ]
      then
          # Rename the unpacked result to the package name if it does not match
          mv $strippedName ${name}
      fi
      
      # Restore write permissions to make building work
      chmod -R u+w ${name}
      
      # Include the dependencies of the package
      cd ${name}
      ${includeDependencies { inherit dependencies; }}
      cd ..
    '';

  # Extract the Node.js source code which is used to compile packages with
  # native bindings
  nodeSources = runCommand "node-sources" {} ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv node-* $out
  '';
  
  # Builds and composes an NPM package including all its dependencies
  buildNodePackage = { name, version, dependencies ? [], production ? true, npmFlags ? "", ... }@args:
    
    stdenv.mkDerivation (builtins.removeAttrs args [ "dependencies" ] // {
      name = "node-${name}-${version}"; # TODO: node version reflected in package name
      buildInputs = [ python nodejs ] ++ stdenv.lib.optional (stdenv.isLinux) utillinux ++ args.buildInputs or [];
      dontStrip = args.dontStrip or true; # Striping may fail a build for some package deployments
      
      unpackPhase = args.unpackPhase or "true";
      
      buildPhase = args.buildPhase or "true";
      
      installPhase = args.installPhase or ''
        # Create and enter a root node_modules/ folder
        mkdir -p $out/lib/node_modules
        cd $out/lib/node_modules
          
        # Compose the package and all its dependencies
        ${composePackage args}
        
        # Patch the shebangs of the bundled modules to prevent them from
        # calling executables outside the Nix store as much as possible
        patchShebangs .
        
        # Deploy the Node.js package by running npm install. Since the
        # dependencies have been provided already by ourselves, it should not
        # attempt to install them again, which is good, because we want to make
        # it Nix's responsibility. If it needs to install any dependencies
        # anyway (e.g. because the dependency parameters are
        # incomplete/incorrect), it fails.
        #
        # The other responsibilities of NPM are kept -- version checks, build
        # steps, postprocessing etc.
        
        cd ${name}
        export HOME=$TMPDIR
        npm --registry http://www.example.com --nodedir=${nodeSources} ${npmFlags} ${stdenv.lib.optionalString production "--production"} install
        
        # Create symlink to the deployed executable folder, if applicable
        if [ -d "$out/lib/node_modules/.bin" ]
        then
            ln -s $out/lib/node_modules/.bin $out/bin
        fi
        
        # Create symlinks to the deployed manual page folders, if applicable
        if [ -d "$out/lib/node_modules/${name}/man" ]
        then
            mkdir -p $out/share
            for dir in "$out/lib/node_modules/${name}/man/"*
            do
                mkdir -p $out/share/man/$(basename "$dir")
                for page in "$dir"/*
                do
                    ln -s $page $out/share/man/$(basename "$dir")
                done
            done
        fi
      '';
    });

  # Builds a development shell
  buildNodeShell = { name, version, src, dependencies ? [], ... }@args:
    let
      nodeDependencies = stdenv.mkDerivation {
        name = "node-dependencies-${name}-${version}";
        buildCommand = ''
          mkdir -p $out/lib
          cd $out/lib
          ${includeDependencies { inherit dependencies; }}
        '';
      };
    in
    stdenv.mkDerivation {
      name = "node-shell-${name}-${version}";
    
      buildCommand = "true";
      
      # Provide the dependencies in a development shell through the NODE_PATH environment variable
      shellHook = stdenv.lib.optionalString (dependencies != []) ''
        export NODE_PATH=${nodeDependencies}/lib/node_modules
      '';
    };
in
{ inherit buildNodeSourceDist buildNodePackage buildNodeShell; }
