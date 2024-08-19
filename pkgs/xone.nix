{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xone";
  version = "0.3-unstable-2024-03-16-pair-patch";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xone";
    rev = "3463d0e2335998c1b94bb1605dc7a6668d4ba262";
    hash = "";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description =
      "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/medusalix/xone";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    platforms = platforms.linux;
  };
})
