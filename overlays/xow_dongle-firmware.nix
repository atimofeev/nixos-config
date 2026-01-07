_final: prev: {
  xow_dongle-firmware = prev.xow_dongle-firmware.overrideAttrs (_old: {
    installPhase = ''
      install -Dm644 xow_dongle.bin $out/lib/firmware/xow_dongle.bin
      install -Dm644 xow_dongle_045e_02e6.bin $out/lib/firmware/xow_dongle_045e_02e6.bin
      install -Dm644 xow_dongle.bin $out/lib/firmware/xone_dongle_02fe.bin
      install -Dm644 xow_dongle_045e_02e6.bin $out/lib/firmware/xone_dongle_02e6.bin
    '';
  });
}
