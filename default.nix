with import <mypkgs>;
let gitit =

# Just use this middle part when embedding in nixpkgs:

{ fetchgit, haskellngPackages, graphviz }:

haskellngPackages.mkDerivation {
  pname   = "gitit";
  version = "0.10.6.2";
  # src = fetchgit {
  #   url = "https://github.com/jefdaj/gitit.git";
  #   rev = "3525826b0c88bfab31ebab1694189292d0ecadfa";
  #   sha256 = "a9f15d7fb39c891c3fe5e7030660ec0ebf82feca933e423e54108639d680486b";
  # };
  src = ./.;
  isLibrary    = true;
  isExecutable = true;
  jailbreak    = true;
  # TODO where to add graphviz?
  buildDepends = with haskellngPackages; [
    # copied from hackage-packages.nix
    aeson base base64-bytestring blaze-html bytestring ConfigFile
    containers directory feed filepath filestore ghc ghc-paths
    happstack-server highlighting-kate hoauth2 hslogger HStringTemplate
    HTTP http-client-tls http-conduit json mtl network network-uri
    old-locale old-time pandoc pandoc-types parsec pretty process
    random recaptcha safe SHA split syb tagsoup text time uri url
    utf8-string uuid xhtml xml xss-sanitize zlib
    # my additional dependencies
    canonical-filepath pandoc-citeproc
  ];
  # meta = {
    homepage    = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license     = "GPL"; # TODO get from stdenv?
    # platforms = self.ghc.meta.platforms; # TODO add this back?
  # };
}

; in callPackage gitit {}
