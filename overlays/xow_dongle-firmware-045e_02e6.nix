final: prev: {
  xow_dongle-firmware-045e_02e6 = prev.xow_dongle-firmware.overrideAttrs
    (old: rec {
      version = "045e_02e6";
      src = prev.fetchurl {
        url =
          "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2015/12/20810869_8ce2975a7fbaa06bcfb0d8762a6275a1cf7c1dd3.cab";
        sha256 = "sha256-5jiKJ6dXVpIN5zryRo461V16/vWavDoLUICU4JHRnwg=";
      };
      unpackCmd = ''
        cabextract -F FW_ACC_00U.bin ${src}
      '';
      installPhase = ''
        install -Dm644 FW_ACC_00U.bin ${
          placeholder "out"
        }/lib/firmware/xow_dongle_045e_02e6.bin
      '';
    });
}
