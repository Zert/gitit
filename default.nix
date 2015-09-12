{ fetchgit, haskellngPackages, graphviz }:

haskellngPackages.mkDerivation {
  pname   = "gitit";
  version = "0.10.6.3";
  src = ./.;
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
  homepage    = "http://gitit.net";
  description = "Wiki using happstack, git or darcs, and pandoc";
  license     = "GPL";
  platforms   = haskellngPackages.ghc.meta.platforms;
}
