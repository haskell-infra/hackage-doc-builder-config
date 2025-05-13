# To deploy:
#  1. Add module to system configuration.
#  2. Switch to configuration.
#  3. Populate /var/lib/hackage-doc-builder/build-cabal/hackage-build-config
#     with credentials.

{ pkgs, ... }:

{
  users.users.hackage-doc-builder = {
    isSystemUser = true;
    description = "Hackage documentation builder";
    group = "hackage-doc-builder";
  };
  users.groups.hackage-doc-builder = {};

  systemd.services.hackage-doc-builder = {
    script = ''
      rm -f build-cache/tmp-install/cabal.project
      rm -Rf "$HOME"
      mkdir -p "$HOME"

      timeout -k 1m 140m \
        ${pkgs.run-hackage-build}/bin/hackage-build build \
        --build-attempts=2 \
        --run-time=120 \
        --build-order=recent-uploads-first
    '';
    environment.HOME = "%T/hackage-doc-builder";
    serviceConfig = {
      Restart = "always";
      RestartSec = 1;
      RestartSteps = 10;
      RestartMaxDelaySec = 300;

      User = "hackage-doc-builder";
      Group = "hackage-doc-builder";
      WorkingDirectory = "%S/hackage-doc-builder";
      StateDirectory = "hackage-doc-builder";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
