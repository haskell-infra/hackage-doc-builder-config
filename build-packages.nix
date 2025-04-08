# Packages available to packages built using the Hackage Haddock builder
{ pkgs }:

with pkgs; [
  blas
  brotli
  bzip2
  freealut
  freeglut
  freetds
  freetype
  glew
  gsl
  haskellPackages.c2hs
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

