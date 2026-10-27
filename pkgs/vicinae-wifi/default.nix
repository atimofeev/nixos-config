{
  esbuild,
  lib,
  networkmanager,
  nodejs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "wifi-picker";
  src = ./.;

  nativeBuildInputs = [
    esbuild
    nodejs
  ];
  strictDeps = true;

  postPatch = ''
    substituteInPlace src/nmcli.ts \
      --replace-fail '@nmcli@' '${lib.getExe' networkmanager "nmcli"}'
  '';

  buildPhase = ''
    runHook preBuild
    esbuild src/wifi.tsx --bundle --platform=node --format=cjs --jsx=automatic \
      --external:react --external:react/jsx-runtime --external:@vicinae/api \
      --outfile=wifi.js
    esbuild src/nmcli.test.ts --bundle --platform=node --format=cjs --outfile=nmcli.test.cjs
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    node --test nmcli.test.cjs
    node --check wifi.js
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp package.json wifi.js $out/
    cp -r assets $out/
    runHook postInstall
  '';

  meta = {
    description = "Pick and toggle NetworkManager Wi-Fi networks from Vicinae";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
