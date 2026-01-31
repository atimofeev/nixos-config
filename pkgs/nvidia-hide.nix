{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (_finalAttrs: rec {
  pname = "nvidia-hide";
  version = "f67fb9a84f8764dc301027908fecfb35b005e431";

  src = fetchFromGitHub {
    owner = "Kelsios";
    repo = "libnvidia-hide";
    rev = version;
    hash = "sha256-P3/j/lC34daUsotjrKqjnrp6NNurrarrBCZv3931gd4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/Kelsios/libnvidia-hide";
    description = "LD_PRELOAD workaround for Electron dGPU wakeups";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    mainProgram = "nvidia-hide";
  };
})
