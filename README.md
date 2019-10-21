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
$ cabal haddock
```
Next build a tarball from the result:
```
$ cp -R dist-newstyle/build/*/*/*/doc/html $PKG-$VERSION-docs
$ tar -cz --format=ustar -f docs.tar.gz $PKG-$VERSION-docs
```
This tarball can be uploaded to Hackage with `curl`:
```
$ curl -X PUT \
    -H 'Content-Type: application/x-tar' \
    -H 'Content-Encoding: gzip' \
    --data-binary \
    @docs.tar.gz \
    https://$USERNAME:$PASSWORD@hackage.haskell.org/package/$PKG-$VERSION/docs
```
Where,
 * `$USERNAME` is your Hackage username
 * `$PASSWORD` is your Hackage password
 * `$PKG` and `$VERSION` are the package name and version, respectively.
