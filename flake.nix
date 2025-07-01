{
  description = "Python and Sage environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, treefmt-nix }:
    let
      inherit (nixpkgs) lib;
      systems = lib.genAttrs lib.systems.doubles.all (any: any);
      eachSystem = lib.genAttrs [ systems.x86_64-linux ];
      eachSystemPkgs = f: eachSystem (system: f nixpkgs.legacyPackages.${system});
      
      # Formatting configuration and build
      treefmtConfig = {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true;
          deadnix.enable = true;
          ruff-format.enable = true;
        };
      };
      treefmtBuild = eachSystemPkgs (pkgs: (treefmt-nix.lib.evalModule pkgs treefmtConfig).config.build);
    in
    {
      formatter = eachSystem (system: treefmtBuild.${system}.wrapper);
      checks = eachSystem (system: {
        formatting = treefmtBuild.${system}.check self;
      });
      devShells = eachSystemPkgs (
        pkgs:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # python3
              sageWithDoc
              git
            ];
          };
        }
      );
    };
}
