final: prev: {
  xow_dongle-firmware = prev.xow_dongle-firmware.overrideAttrs (old: {
    version = "2015-12";
    src = prev.fetchurl {
      url =
        "https://catalog.s.download.windowsupdate.com/d/msdownload/update/driver/drvs/2015/12/20810867_1b8b44bdbdc6a6c60a224d3110c8360d95611b26.cab";
      sha256 = "sha256-OPBOIIqveu4W5rWIY8szL4IuAHPsjGQ4m6apR2/+5os=";
    };
  });
}
