{ lib, ... }: {
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # Use different keyboard language for each window
      per-window = true;
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "ru" ])
      ];
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 275;
      repeat-interval = lib.hm.gvariant.mkUint32 35;
    };
  };
}
