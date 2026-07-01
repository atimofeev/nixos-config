{ config, lib, ... }:
let
  i = lib.hm.gvariant.mkUint32;
  t = lib.hm.gvariant.mkTuple;
  inherit (config.custom-hm.user.input.xkb) layout options;
  layouts_split = lib.strings.splitString "," layout;
  options_split = lib.strings.splitString "," options;
in
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # Use different keyboard language for each window
      per-window = true;
      sources = builtins.map (
        l:
        (t [
          "xkb"
          l
        ])
      ) layouts_split;
      xkb-options = options_split;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = i config.custom-hm.user.input.repeat-delay;
      repeat-interval = i config.custom-hm.user.input.repeat-rate;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
  };
}
