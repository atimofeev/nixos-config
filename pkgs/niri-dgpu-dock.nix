{
  lib,
  makeWrapper,
  python3,
  stdenvNoCC,
}:
let
  python = python3.withPackages (ps: [
    ps.dbus-next
    ps.pyudev
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "niri-dgpu-dock";
  version = "1";
  src = ./niri-dgpu-dock;

  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=${./niri-session} \
      ${python}/bin/python -m unittest discover -v
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 dock.py $out/libexec/niri-dgpu-dock/dock.py
    install -Dm644 ${./niri-session/niri_session.py} $out/libexec/niri-dgpu-dock/niri_session.py
    makeWrapper ${python}/bin/python $out/bin/niri-dgpu-dock \
      --add-flags "$out/libexec/niri-dgpu-dock/dock.py"
    runHook postInstall
  '';

  meta = {
    description = "Automatic Niri dGPU power saving on battery without attached displays";
    mainProgram = "niri-dgpu-dock";
    platforms = lib.platforms.linux;
  };
}
