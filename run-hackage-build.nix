{ pkgs, writeTextFile, buildFHSEnv, ... }:

let
  ghc = pkgs.haskell.compiler.ghc984;

  deps = pkgs.callPackage ./build-depends.nix {};
  f = pkg: ''
    NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.lib.getLib pkg}/lib"
    NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -L${pkgs.lib.getLib pkg}/lib"
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${pkgs.lib.getInclude pkg}/include"
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${pkgs.lib.getDev pkg}/lib/pkgconfig"
  '';

in
pkgs.writeScriptBin "hackage-build" ''
  #!/bin/sh
  PATH="$PATH:${ghc}/bin:${pkgs.curl}/bin:${pkgs.cabal-install}/bin:${pkgs.pkg-config}/bin"

  ${pkgs.lib.concatMapStringsSep "\n" f deps}
  export NIX_LDFLAGS
  export NIX_CFLAGS_COMPILE
  export PKG_CONFIG_PATH

  ${pkgs.hackage-server}/bin/hackage-build $@
''
