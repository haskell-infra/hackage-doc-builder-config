{
  description = "Hackage documentation builder configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.hackage-server.url = "github:bgamari/hackage-server/wip/doc-builder-tls";
  inputs.cabal.url = "github:haskell/cabal/cabal-install-v3.12.1.0";
  inputs.cabal.flake = false;
  inputs.hackage-security.url = "github:haskell/hackage-security/hackage-security/v0.6.2.6";
  inputs.hackage-security.flake = false;

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
          inherit (pkgs) cabal-install;
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
            drv = self.packages.${system}.run-hackage-build;
            exePath = "/bin/hackage-build";
          };

          default = hackage-build;
        };
      }
    ) // {
      nixOverlays.default = self2: super2: {
        hackage-server = inputs.hackage-server.packages.x86_64-linux.hackage-server;
        inherit (self.packages.x86_64-linux) run-hackage-build;

        cabal-install = self2.haskellPackages.callCabal2nix "cabal-install" "${inputs.cabal}/cabal-install" { inherit (self2) Cabal cabal-install-solver hackage-security; };
        cabal-install-solver = self2.haskellPackages.callCabal2nix "cabal-install-solver" "${inputs.cabal}/cabal-install-solver" { inherit (self2) Cabal; };
        Cabal = self2.haskellPackages.callCabal2nix "Cabal" "${inputs.cabal}/Cabal" { inherit (self2) Cabal-syntax; };
        Cabal-syntax = self2.haskellPackages.callCabal2nix "Cabal-syntax" "${inputs.cabal}/Cabal-syntax" { };
        Cabal-described = self2.haskellPackages.callCabal2nix "Cabal-described" "${inputs.cabal}/Cabal-described" { };
        Cabal-QuickCheck = self2.haskellPackages.callCabal2nix "Cabal-QuickCheck" "${inputs.cabal}/Cabal-QuickCheck" { };
        Cabal-tests = self2.haskellPackages.callCabal2nix "Cabal-tests" "${inputs.cabal}/Cabal-tests" { };
        Cabal-tree-diff = self2.haskellPackages.callCabal2nix "Cabal-tree-diff" "${inputs.cabal}/Cabal-tree-diff" { };
        hackage-security = self2.haskellPackages.callCabal2nix "hackage-security" "${inputs.hackage-security}/hackage-security" { inherit (self2) Cabal Cabal-syntax; };
      };

      nixosModules.doc-builder = {pkgs, ...}: {
        imports = [
          ./deploy.nix
        ];

        nixpkgs.overlays = [ self.nixOverlays.default ];
      };
    };
}
