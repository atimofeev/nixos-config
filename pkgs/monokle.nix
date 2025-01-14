{ lib, buildNpmPackage, fetchFromGitHub, electron, nix-update-script
, makeBinaryWrapper, }:
let version = "2.4.8";
in buildNpmPackage {
  pname = "monokle";
  inherit version;

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "monokle";
    rev = "refs/tags/v${version}";
    hash = "";
  };

  npmDepsHash = "";

  nativeBuildInputs = [ makeBinaryWrapper ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  # # FIXME: Git dependency node_modules/register-scheme contains install scripts,
  # # but has no lockfile, which is something that will probably break.
  # forceGitDeps = true;

  makeCacheWritable = true;

  buildPhase = ''
    runHook preBuild

    # NOTE: Upstream explicitly opts to not build an ASAR as it would cause all
    # text to disappear in the app.
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/*-unpacked $out/dist

    install -Dm644 com.github.hmlendea.geforcenow-electron.desktop -t $out/share/applications
    install -Dm644 icon.png $out/share/icons/hicolor/512x512/apps/geforcenow-electron.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/dist/geforcenow-electron $out/bin/geforcenow-electron \
      --add-flags "--no-sandbox --disable-gpu-sandbox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"

    substituteInPlace $out/share/applications/com.github.hmlendea.geforcenow-electron.desktop \
      --replace-fail "/opt/geforcenow-electron/geforcenow-electron" "geforcenow-electron" \
      --replace-fail "Icon=nvidia" "Icon=geforcenow-electron"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes IDE";
    homepage = "https://github.com/kubeshop/monokle";
    license = lib.licenses.mit;
    platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
    maintainers = with lib.maintainers; [ atimofeev ];
    mainProgram = "monokle";
  };
}
