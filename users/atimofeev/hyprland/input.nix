{ config, lib, ... }:
let
  f2s = lib.strings.floatToString;
  inherit (config.custom-hm.user.input) touchpad-sensitivity;
in
{
  wayland.windowManager.hyprland.settings = {

    device = [
      {
        name = "etd2303:00-04f3:3083-touchpad";
        sensitivity = f2s touchpad-sensitivity;
      }
      {
        name = "asuf1209:00-2808:0219-touchpad";
        sensitivity = f2s touchpad-sensitivity;
      }
    ];

    input = {
      accel_profile = "adaptive";
      kb_layout = config.custom-hm.user.input.xkb.layout;
      kb_options = config.custom-hm.user.input.xkb.options;
      numlock_by_default = true;
      repeat_delay = config.custom-hm.user.input.repeat-delay;
      repeat_rate = config.custom-hm.user.input.repeat-rate;
      sensitivity = -0.8;

      touchpad.natural_scroll = 1;

      touchdevice.output = "DP-1";
    };

    gesture = [
      "3, horizontal, workspace"
    ];

  };
}
