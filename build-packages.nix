# Packages available to packages built using the Hackage Haddock builder
{ pkgs }:

with pkgs; [
  haskellPackages.alex
  haskellPackages.c2hs
  haskellPackages.happy

  blas
  brotli
  bzip2
  freealut
  freeglut
  freetds
  freetype
  glew
  gsl
  icu
  lapack
  libGLU
  libevdev
  libglvnd
  libsodium
  ncurses
  openal
  openssl
  postgresql.lib
  sdl3
  xz
  zeromq4
  zlib
]

