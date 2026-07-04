{ config, ... }:
{

  wayland.windowManager.niri.settings.input = {

    keyboard = {
      xkb = {
        inherit (config.custom-hm.user.input.xkb) layout options;
      };
      numlock = { };
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
      dwt = { };
      natural-scroll = { };
      tap = { };
    };

    touch.map-to-output = "Lenovo Group Limited M14t V309WMZ3";

    focus-follows-mouse._props = {
      max-scroll-amount = "51%";
    };

    warp-mouse-to-focus._props = {
      mode = "center-xy-always";
    };

  };

}
