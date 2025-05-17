# Packages available to packages built using the Hackage Haddock builder
{ pkgs }:

with pkgs; [
  # Native build tools
  autoconf
  automake
  libtool
  bash
  bintools
  m4
  gnused
  gawk

  # Haskell build tools
  # These should really be handled via build-tool-depends declared in the cabal
  # file. However, the doc builder currently ignores such dependencies due to
  # https://github.com/haskell/hackage-server/issues/1393. Drop these once
  # that issue is executed.
  haskellPackages.alex
  haskellPackages.BNFC
  haskellPackages.c2hs
  haskellPackages.cpphs
  haskellPackages.happy
  haskellPackages.hspec-discover
  haskellPackages.markdown-unlit
  haskellPackages.tasty-discover

  # Native libraries
  blas
  brotli
  bzip2
  freealut
  freeglut
  freetds
  freetype
  glew
  glfw
  gsl
  hdf5
  icu
  lapack
  libGLU
  libevdev
  libglvnd
  libjpeg
  libsodium
  ncurses
  openal
  openssl
  pcre
  postgresql.lib
  sdl3
  xz
  zeromq4
  zlib
]

