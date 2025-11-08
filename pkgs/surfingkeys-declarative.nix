{
  buildNpmPackage,
  cairo,
  fetchFromGitHub,
  lib,
  node-gyp,
  pango,
  pixman,
  pkg-config,
  webpack-cli,
}:

buildNpmPackage {
  pname = "surfingkeys-declarative";
  version = "248bab9";

  src = fetchFromGitHub {
    owner = "bitbloxhub";
    repo = "Surfingkeys-declarative";
    rev = "248bab90685f1d0b5cdf8c11ac0ce4c39089cdc1";
    hash = "sha256-17aez95vTBYzZQm8KVk8XSTYTgGogQwJIZVwWYWfeIU=";
  };

  npmDepsHash = "sha256-kawFUKPY8tOwrmOd1azDCT0RxWEvHWDmoIvq6vObLbY=";

  buildInputs = [
    pixman
    cairo
    pango
  ];

  nativeBuildInputs = [
    webpack-cli
    node-gyp
    pkg-config
  ];

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  buildPhase = ''
    browser=firefox npm run build:prod
  '';

  installPhase = ''
    mkdir -p $out
    cp dist/production/firefox/sk.zip $out/firefox.xpi
  '';

  meta = {
    homepage = "https://github.com/bitbloxhub/Surfingkeys-declarative";
    description = "Map your keys for web surfing, expand your browser with javascript and keyboard. ";
    licenses = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atimofeev ];
  };

}
