{
  buildNpmPackage,
  fetchurl,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  nodejs_latest,
  ripgrep,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.74.0";

  # Create a source with package-lock.json included
  srcWithLock = runCommand "pi-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
        hash = "sha256-l0pzuWGVvX1jDhFYaey14N16XDo47kkm3JlEhmPUo0Q=";
      }
    } -C $out --strip-components=1
    cp ${./pi-package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  inherit version;
  pname = "pi";

  src = srcWithLock;

  npmDepsHash = "sha256-MqNwwTCAMzobhiu7O9/K8thoJDKQ9X15LQ++OEh/tSw=";
  makeCacheWritable = true;

  # The package from npm is already built
  dontNpmBuild = true;
  dontNpmPrune = true;

  # Skip native module rebuild
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/pi" \
      --set NPM_CONFIG_PREFIX "/home/atimofeev/.pi/npm/" \
      --set AWS_PROFILE "ai" \
      --set PI_SKIP_VERSION_CHECK 1 \
      --set PI_TELEMETRY 0 \
      --prefix PATH : "${
        lib.makeBinPath [
          ripgrep
          nodejs_latest
        ]
      }"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgram = "${placeholder "out"}/bin/pi";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal-based coding agent with multi-model support";
    homepage = "https://pi.dev/";
    changelog = "https://github.com/earendil-works/pi/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "pi";
  };
}
