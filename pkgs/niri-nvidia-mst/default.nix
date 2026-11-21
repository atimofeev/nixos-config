{
  lib,
  makeWrapper,
  nvidiaPackage,
  python3,
  stdenv,
}:
let
  python = python3.withPackages (ps: [
    ps.dbus-next
    ps.pyudev
  ]);
in
stdenv.mkDerivation {
  pname = "niri-nvidia-mst";
  inherit (nvidiaPackage) version;

  src = nvidiaPackage.open.src;
  patches = nvidiaPackage.open.patches or [ ];
  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    $CC -std=gnu11 -Wall -Wextra -Werror -O2 \
      -Isrc/nvidia-modeset/interface \
      -Isrc/common/sdk/nvidia/inc \
      -Isrc/common/inc \
      -Isrc/common/unix/common/inc \
      -Ikernel-open/common/inc \
      -Isrc/nvidia/arch/nvalloc/unix/include \
      ${./probe.c} -o nvidia-mst-probe
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=${../niri-session} \
      ${python}/bin/python -m unittest discover -s ${./.} -p 'test_*.py' -v
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 nvidia-mst-probe $out/libexec/niri-nvidia-mst/nvidia-mst-probe
    install -Dm644 ${./watcher.py} $out/libexec/niri-nvidia-mst/watcher.py
    install -Dm644 ${../niri-session/niri_session.py} $out/libexec/niri-nvidia-mst/niri_session.py
    makeWrapper ${python}/bin/python $out/bin/niri-nvidia-mst \
      --add-flags "$out/libexec/niri-nvidia-mst/watcher.py" \
      --set NVKMS_PROBE "$out/libexec/niri-nvidia-mst/nvidia-mst-probe"
    runHook postInstall
  '';

  meta = {
    description = "Event-driven Niri frame-completion workaround for active NVIDIA MST displays";
    mainProgram = "niri-nvidia-mst";
    platforms = lib.platforms.linux;
  };
}
