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
      while true; do
        rm -f build-cache/tmp-install/cabal.project
        timeout -k 1m 140m \
          ${pkgs.run-hackage-build}/bin/hackage-build build \
          --build-attempts=2 \
          --run-time=120 \
          --build-order=recent-uploads-first
        sleep 300
      done
    '';
    serviceConfig = {
      User = "hackage-doc-builder";
      Group = "hackage-doc-builder";
      WorkingDirectory = "%S/hackage-doc-builder";
      StateDirectory = "hackage-doc-builder";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
