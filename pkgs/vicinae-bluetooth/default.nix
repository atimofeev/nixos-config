{
  esbuild,
  lib,
  nodejs,
  stdenvNoCC,
  systemd,
}:
stdenvNoCC.mkDerivation {
  name = "bluetooth-picker";
  src = ./.;

  nativeBuildInputs = [
    esbuild
    nodejs
  ];
  strictDeps = true;

  postPatch = ''
    substituteInPlace src/bluez.ts \
      --replace-fail '@busctl@' '${lib.getExe' systemd "busctl"}'
  '';

  buildPhase = ''
    runHook preBuild
    esbuild src/bluetooth.tsx --bundle --platform=node --format=cjs --jsx=automatic \
      --external:react --external:react/jsx-runtime --external:@vicinae/api \
      --outfile=bluetooth.js
    esbuild src/bluez.test.ts --bundle --platform=node --format=cjs --outfile=bluez.test.cjs
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    node --test bluez.test.cjs
    node --check bluetooth.js
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp package.json bluetooth.js $out/
    cp -r assets $out/
    runHook postInstall
  '';

  meta = {
    description = "Pick and toggle paired Bluetooth devices from Vicinae";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
