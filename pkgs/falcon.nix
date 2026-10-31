{
  bash,
  buildEnv,
  coreutils,
  dpkg,
  findutils,
  gawk,
  glibc,
  gnugrep,
  gnused,
  gnutar,
  gzip,
  iproute2,
  kmod,
  lib,
  libnl,
  makeWrapper,
  openssl,
  procps,
  requireFile,
  stdenvNoCC,
  systemd,
  util-linux,
  xz,
  zlib,
}:
let
  version = "8.11.0-19508";
  libraries = [
    glibc
    libnl
    openssl
    zlib
  ];
  libraryPath = lib.makeLibraryPath libraries;
  runtime = buildEnv {
    name = "falcon-runtime";
    paths = map lib.getLib libraries ++ [
      bash
      coreutils
      findutils
      gawk
      gnugrep
      gnused
      gnutar
      gzip
      iproute2
      kmod
      procps
      systemd
      util-linux
      xz
    ];
    pathsToLink = [
      "/bin"
      "/lib"
      "/sbin"
    ];
    postBuild = ''
      ln -s /run/booted-system/kernel-modules/lib/modules "$out/lib/modules"
    '';
  };
in
stdenvNoCC.mkDerivation {
  pname = "falcon-sensor";
  inherit version;

  src =
    (requireFile {
      name = "falcon-sensor_${version}_amd64.deb";
      sha256 = "efe5dc643c3dc292e2c7dfd4698315f098e9d76584fa3ac830298c020250aefc";
      message = ''
        Obtain falcon-sensor_${version}_amd64.deb from your security team, then run:
          nix-store --add-fixed sha256 /path/to/falcon-sensor_${version}_amd64.deb
        Do not commit or publish the proprietary installer.
      '';
    }).overrideAttrs
      {
        allowSubstitutes = false;
      };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];
  dontUnpack = true;
  # Preserve vendor binaries, including their interpreter and integrity metadata.
  dontFixup = true;
  allowSubstitutes = false;
  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    dpkg-deb -x "$src" "$out"
    makeWrapper ${glibc}/lib/ld-linux-x86-64.so.2 "$out/bin/falconctl" \
      --add-flags "--library-path ${libraryPath}" \
      --add-flags "$out/opt/CrowdStrike/falconctl"
    makeWrapper ${bash}/bin/bash "$out/bin/falcon-kernel-check" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          gnused
        ]
      } \
      --add-flags "$out/opt/CrowdStrike/falcon-kernel-check"
    runHook postInstall
  '';

  passthru = {
    inherit libraryPath runtime;
  };

  meta = {
    description = "CrowdStrike Falcon Sensor (requires an authorized installer)";
    homepage = "https://www.crowdstrike.com/";
    license = lib.licenses.unfree;
    mainProgram = "falconctl";
    platforms = [ "x86_64-linux" ];
  };
}
