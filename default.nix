# The middle part of this expression can be embedded in nixpkgs;
# the top and bottom adapt it to use the current system instead.

with (import <nixpkgs> {}).pkgs;
with haskellPackages;
let

  # these dependencies are added automatically if you use my nixpkgs repo
  canonicalFilepath =
    # generated by `cabal2nix cabal://canonical-filepath`
    cabal.mkDerivation (self: {
      pname = "canonical-filepath";
      version = "1.0.0.3";
      sha256 = "0dg9d4v08gykbjmzafpakgwc51mq5d5m6ilmhp68czpl30sqjhwf";
      buildDepends = [ deepseq filepath ];
      meta = {
        homepage = "http://github.com/nominolo/canonical-filepath";
        description = "Abstract data type for canonical file paths";
        license = self.stdenv.lib.licenses.bsd3;
        platforms = self.ghc.meta.platforms;
      };
    });
  filestore =
    # generated by `cabal2nix https://github.com/jgm/filestore`
    cabal.mkDerivation (self: {
      pname = "filestore";
      version = "0.6.1";
      src = fetchgit {
        url = "https://github.com/jgm/filestore";
        sha256 = "5fca03c421175e589ae11d3719584a2ceb3cb3e5d7620ef35aa8fb53139e872f";
        rev = "eac539da48a152c1fa9e870238248bd5b6a689d7";
      };
      buildDepends = [ Diff filepath parsec split time utf8String xml ];
      testDepends = [ Diff filepath HUnit mtl time ];
      meta = {
        description = "Interface for versioning file stores";
        license = self.stdenv.lib.licenses.bsd3;
        platforms = self.ghc.meta.platforms;
      };
    });
  gitit =

    # this part is the complete default.nix when added to mypkgs
    { cabal, aeson, base64Bytestring, blazeHtml, ConfigFile, feed
    , filepath, filestore, ghcPaths, happstackServer, highlightingKate
    , hoauth2, hslogger, HStringTemplate, HTTP, httpClientTls
    , httpConduit, json, mtl, network, networkUri, pandoc, pandocTypes
    , parsec, random, recaptcha, safe, SHA, split, syb, tagsoup, text
    , time, uri, url, utf8String, uuid, xhtml, xml, xssSanitize, zlib
    , graphviz, lmodern, canonicalFilepath
    }:
    cabal.mkDerivation (self: {
      pname = "gitit";
      version = "0.10.6.1";
      src = ./.;
      isLibrary = true;
      isExecutable = true;
      jailbreak = true;
      buildDepends = [
        aeson base64Bytestring blazeHtml ConfigFile feed filepath filestore
        ghcPaths happstackServer highlightingKate hoauth2 hslogger
        HStringTemplate HTTP httpClientTls httpConduit json mtl network
        networkUri pandoc pandocTypes parsec random recaptcha safe SHA
        split syb tagsoup text time uri url utf8String uuid xhtml xml
        xssSanitize zlib
        canonicalFilepath graphviz
      ];
      meta = {
        homepage = "http://gitit.net";
        description = "Wiki using happstack, git or darcs, and pandoc";
        license = "GPL";
        platforms = self.ghc.meta.platforms;
      };
    })

; in callPackage gitit {
  inherit canonicalFilepath;
}
