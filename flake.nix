{
  description = "Hackage documentation builder configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.hackage-server.url = "github:bgamari/hackage-server/wip/doc-builder-tls";

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.nixOverlays.default ];
      };
      in {
        packages = rec {
          hackage-server = inputs.hackage-server.packages.${system}.hackage-server;
          run-hackage-build = pkgs.callPackage ./run-hackage-build.nix {};
        };

        apps = rec {
          # Deployment initialization
          init-deployment = flake-utils.lib.mkApp {
            drv = pkgs.writeScriptBin "init-deployment" ''
              #!/bin/sh
              set -e
              cd /var/lib/hackage-doc-builder
              sudo -u hackage-doc-builder ${self.packages.${system}.hackage-server}/bin/hackage-server init
            '';
            exePath = "/bin/init-deployment";
          };

          hackage-build = flake-utils.lib.mkApp {
            drv = self.packages.${system}.hackage-server;
            exePath = "/bin/hackage-build";
          };
        };
      }
    ) // {
      nixOverlays.default = self2: super2: {
        hackage-server = inputs.hackage-server.packages.x86_64-linux.hackage-server;
        inherit (self.packages.x86_64-linux) run-hackage-build;
      };

      nixosModules.doc-builder = {pkgs, ...}: {
        imports = [
          ./deploy.nix
        ];

        nixpkgs.overlays = [ self.nixOverlays.default ];
      };
    };
}
