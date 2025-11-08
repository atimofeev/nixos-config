{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage {
  pname = "darkreader-declarative";
  version = "ae1a068";

  src = fetchFromGitHub {
    owner = "bitbloxhub";
    repo = "darkreader-declarative";
    rev = "ae1a0684699c0a4604bb6f7240424e42d16aa96f";
    hash = "sha256-8DYFpVYQJ3o+lrVpROjYERP+lxLzncgLH1pHPyYtlvQ=";
  };

  npmDepsHash = "sha256-DepBF2OW11W8C5uCFffYn8jTLzf3JWVl64rqLBTzfr0=";

  buildPhase = ''
    npm run build:firefox
  '';

  installPhase = ''
    mkdir -p $out
    cp build/release/darkreader-firefox.xpi $out/firefox.xpi
  '';

  meta = {
    homepage = "https://github.com/bitbloxhub/darkreader-declarative";
    description = "Dark Reader Chrome and Firefox extension";
    licenses = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atimofeev ];
  };

}
