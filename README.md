# hackage-doc-builder-config

This repository contains configuration and administrative documentation for the
documentation builder feeding documentation to <https://hackage.haskell.org>.

# Requesting native libraries

If the documentation for your Hackage package upload fails to build due to a
missing native library you have two options:

 1. If the library is common, packaged for Debian, and small then you can
    petition to have it installed on the Hackage documentation builder by opening a
    merge request adding it to the list of Debian package names in
    [packages.txt](packages.txt) 
  
 2. Otherwise you can upload documentation to Hackage [manually](#manual-upload).


# Manual documentation upload

When native library dependencies aren't available on the Hackage documentation
builder Haddock documentation can always be manually uploaded to Hackage via
Curl. This can be done with `cabal-install` via:
```
$ cabal haddock --haddock-for-hackage
$ cabal upload --documentation --publish
```
