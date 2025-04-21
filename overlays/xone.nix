final: prev: {
  linuxPackages_latest = prev.linuxPackages_latest.extend (lpfinal: lpprev: {
    xone = lpprev.xone.overrideAttrs (oldAttrs: {
      version = "0.3-unstable-2024-12-23";
      src = prev.fetchFromGitHub {
        owner = "dlundqvist";
        repo = "xone";
        rev = "c682b0cd4fd56d2d9639b64787034a375535eb4b";
        sha256 = "sha256-QGmrOCiMa/Nrm2ln7aO+QVL3F5nAK2n6qWMVn+VMwcM=";
      };
      patches = [ ];
    });
  });
}
