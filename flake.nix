{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bico = {
      url = "git+ssh://git@github.com/GeoTop-UB/BiCo.git?ref=main";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    gitignore,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        # packageJSON = pkgs.lib.importJSON ./package.json;
        # gitignoreSource = gitignore.lib.gitignoreSource;
      in {
        # packages = rec {
        #   site-src = pkgs.mkYarnPackage rec {
        #     name = "${packageJSON.name}-site-${version}";
        #     version = packageJSON.version;
        #     src = gitignoreSource ./.;
        #     packageJson = "${src}/package.json";
        #     yarnLock = "${src}/yarn.lock";
        #     buildPhase = ''
        #       yarn --offline build
        #     '';
        #     distPhase = "true";
        #   };

        #   default = pkgs.writeShellApplication {
        #     name = packageJSON.name;
        #     runtimeInputs = [site-src pkgs.nodejs];
        #     text = ''
        #       node ${site-src}/libexec/${packageJSON.name}/deps/${packageJSON.name}/build
        #     '';
        #   };
        # };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            yarn 
            nodejs
            uv
            sshpass
            sageWithDoc
            gnugrep
            findutils
          ];
          # shellHook = ''
          #   uv run --with python-minifier==3.0.0 pyminify "${inputs.bico}/bigraded_complexes.py.sage" --output src/lib/assets/bico.py.sage --no-combine-imports --remove-literal-statements
          # '';
        };
      }
    );
}