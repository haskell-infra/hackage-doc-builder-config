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
  pkg-config

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
  blas # blas-ffi
  brotli
  bzip2 # bnb-staking-csvs
  curl # curl
  expat # cairo-image
  freealut
  freeglut
  freetds
  freetype
  fribidi # simple-pango
  glew
  glfw
  gsl
  hdf5
  icu
  lapack # lapack-ffi
  libdatrie # simple-pango
  libevdev
  libGL # GLUT, etc.
  libGLU # GLURaw
  libglvnd
  libjpeg
  libselinux # simple-pango
  libsepol # simple-pango
  libsodium # libsodium-bindings
  libthai # simple-pango
  libxml2 # c14n
  ncurses
  nettle # nettle
  nlopt # srtree
  openal # OpenAL
  openssl
  pango # simple-pango
  pcre # regex-pcre
  pcre2 # simple-cairo
  postgresql
  sdl3
  systemdMinimal # hidapi requires udev
  util-linux # simple-pango requires mount
  xorg.libX11 # GLFW-b
  xorg.libXcursor # GLFW-b
  xorg.libXdmcp # simple-cairo
  xorg.libXi # GLFW-b
  xorg.libXinerama # GLFW-b
  xorg.libXrandr # GLFW-b
  xorg.libXxf86vm # GLFW-b
  xz # lzma
  zeromq4
  zlib
]

