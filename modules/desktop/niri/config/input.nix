{ config, ... }:
{

  programs.niri.settings.input = {

    keyboard = {
      xkb = {
        inherit (config.custom-hm.user.input.xkb) layout options;
      };
      numlock = true;
      inherit (config.custom-hm.user.input) repeat-delay repeat-rate;
      track-layout = "window";
    };

    mouse = {
      accel-profile = "flat";
      # accel-speed = config.custom-hm.user.input.mouse-sensitivity;
      accel-speed = config.custom-hm.user.input.touchpad-sensitivity;
    };

    touchpad = {
      accel-profile = "flat";
      accel-speed = config.custom-hm.user.input.touchpad-sensitivity;
      click-method = "button-areas";
      dwt = true;
      natural-scroll = true;
    };

    touch.map-to-output = "Lenovo Group Limited M14t V309WMZ3";

    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "51%";
    };

    warp-mouse-to-focus.enable = true;

  };

}
