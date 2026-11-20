# Packaging quirks:
# - Proprietary .deb supplied by the security team; requireFile below documents
#   the exact filename, checksum, and local import command. Never upload this
#   package/closure to public caches; allowSubstitutes does not prevent uploads.
# - No vendor patches or Debian maintainer scripts: preserve ELF integrity and
#   run falconctl through the Nix glibc loader. modules/work/falcon.nix supplies
#   service-local FHS bind mounts and writable state under /opt/CrowdStrike.
# - Binary self-updates are not integrated; use Nix-managed installer upgrades
#   coordinated with sensor update policy and maintenance protection.
# - In 8.11, --backend=bpf is ignored. The bundled kernel check's default regex
#   can falsely match; use falcon-kernel-check -k "$(uname -r)". This checks only
#   the bundled kernel-mode list, not BPF compatibility or full protection.
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
  payload = stdenvNoCC.mkDerivation {
    pname = "falcon-sensor-payload";
    inherit src version;

    nativeBuildInputs = [ dpkg ];
    dontUnpack = true;
    dontFixup = true;
    allowSubstitutes = false;
    preferLocalBuild = true;

    # Pin the vendor tree, not the extraction toolchain or runtime dependencies.
    # On sensor upgrades, update this recursive hash as well as the installer hash.
    outputHash = "sha256-ixxW+2KoNwZYeOIHZqWyA7W2VVsfe6PLeCDErVKXQ/Y=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    installPhase = ''
      runHook preInstall
      dpkg-deb -x "$src" extracted
      cp -a extracted/opt/CrowdStrike "$out"
      runHook postInstall
    '';
  };
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
  inherit src version;

  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  # Preserve vendor binaries, including their interpreter and integrity metadata.
  dontFixup = true;
  allowSubstitutes = false;
  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/opt"
    ln -s ${payload} "$out/opt/CrowdStrike"
    makeWrapper ${glibc}/lib/ld-linux-x86-64.so.2 "$out/bin/falconctl" \
      --add-flags "--library-path ${libraryPath}" \
      --add-flags "${payload}/falconctl"
    makeWrapper ${bash}/bin/bash "$out/bin/falcon-kernel-check" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          gnused
        ]
      } \
      --add-flags "${payload}/falcon-kernel-check"
    runHook postInstall
  '';

  passthru = {
    inherit libraryPath payload runtime;
  };

  meta = {
    description = "CrowdStrike Falcon Sensor (requires an authorized installer)";
    homepage = "https://www.crowdstrike.com/";
    license = lib.licenses.unfree;
    mainProgram = "falconctl";
    platforms = [ "x86_64-linux" ];
  };
}
