{ pkgs, writeTextFile, ... }:

let
  ghc = pkgs.haskell.compiler.ghc984;

  deps = pkgs.callPackage ./build-depends.nix {};

  mkShellFrag = pkg: ''
    PATH="$PATH:${pkg}/bin"
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgs.lib.getDev pkg}/lib/pkgconfig"
  '';

  mkCabalFrag = pkg: ''
    extra-lib-dirs: ${pkgs.lib.getLib pkg}/lib
    extra-include-dirs: ${pkgs.lib.getInclude pkg}/include
  '';

  cabalFrag = pkgs.writeText "cabal-fragment"
    (pkgs.lib.concatMapStringsSep "\n" mkCabalFrag deps);

  # This is a wrapper of cabal-install which derives a new cabal.config
  # containing extra-lib-dirs and extra-include-dirs of the configured
  # build dependencies.
  cabal-install = pkgs.writeScriptBin "cabal" ''
    config="$(mktemp cabal-config.XXX)"
    args=()
    while [[ $# -gt 0 ]]; do
      case $1 in
        --config-file=*)
          cfg="''${1#*=}"
          cat "$cfg" >> "$config"
          shift ;;
        --config-file)
          shift
          cat "$cfg" >> "$config"
          shift ;;
        *) args=( "''${args[@]}" "$1" ); shift ;;
      esac
    done

    cat ${cabalFrag} >> $config

    ${pkgs.cabal-install}/bin/cabal --config-file=$config ''${args[@]}
    ret=$?
    rm $config
    exit $?
  '';

  script = ''
    #!/bin/sh
    PATH="$PATH:${ghc}/bin:${pkgs.curl}/bin:${cabal-install}/bin:${pkgs.pkg-config}/bin"
    export PATH

    ${pkgs.lib.concatMapStringsSep "\n" mkShellFrag deps}
    export PKG_CONFIG_PATH

    ${pkgs.hackage-server}/bin/hackage-build $@
  '';

in
  pkgs.writeScriptBin "hackage-build" script
