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
      ${pkgs.run-hackage-build}/bin/hackage-build build \
        --continuous \
        --keep-going \
        --build-attempts=3 \
        --build-order=latest-version-first
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
