# This file was generated by `cabal2nix ./. > shell.nix`,
# then edited to work as a development environment
# and to include custom dependencies from github.
#
# Use `nix-shell --pure` to set everything up.
# It might take a while to build everything the first time,
# but after that it'll be faster than plain cabal.
#
# Because it's "pure" (all dependencies are explicit),
# you need to add your text editor and any other tools
# to devDepends below.

# TODO depend on custom filestore, not the system one!
# TODO rewrite gitit.sh to use nix rather than custom build
# TODO is there an official attr for runDepends?
# TODO add pkill to runDepends
# TODO expand root partition, then add texlive to runDepends
# TODO make sure http-conduit and json match with the filestore versions
# TODO can you pass haskellPackages to fetchgit??
#      if so, could use stable version:
# , myFilestore ? (pkgs.fetchgit {
#     url = "https://github.com/jefdaj/filestore.git";
#     rev = "2a09b62726e8fd35a156bbeda919e552d914daad";
#     sha256 = "75ed42343f25e54db1c6c369d96738e76dca41df398ff9ad9cb85abfdeac25f0";
#   })
# TODO don't depend on the location of ../filestore

{ pkgs ? (import <nixpkgs> {}).pkgs
, myFilestore ? (import ../filestore pkgs.haskellPackages)
}:

let
  # haskellPackages = pkgs.haskellPackages // { filestore = myFilestore; };
  inherit (pkgs) haskellPackages;

  runDepends = with pkgs; [
    R
    bash
    graphviz
    perl
    python
  ];

  devDepends = with pkgs; [
    haskellPackages.cabalInstall
    git
    less
    vim
  ];

  # myFilestore = pkgs.fetchgit {
  #   url = "https://github.com/jefdaj/filestore.git";
  #   rev = "2a09b62726e8fd35a156bbeda919e552d914daad";
  #   sha256 = "75ed42343f25e54db1c6c369d96738e76dca41df398ff9ad9cb85abfdeac25f0";
  # };

in haskellPackages.cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.10.5.1";
  src = ./.;
  isLibrary = true;
  isExecutable = true;

  buildDepends = with haskellPackages; devDepends ++ runDepends ++ [
    aeson base64Bytestring blazeHtml ConfigFile feed filepath myFilestore
    ghcPaths happstackServer highlightingKate hoauth2 hslogger
    HStringTemplate HTTP httpClientTls httpConduit json mtl network
    networkUri pandoc pandocTypes parsec random recaptcha safe SHA
    split syb tagsoup text time uri url utf8String uuid xhtml xml
    xssSanitize zlib
  ];

  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
