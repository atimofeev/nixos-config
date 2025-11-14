{ vars, ... }:
{

  programs.niri.settings.input = {

    keyboard = {
      xkb = {
        layout = vars.kb_layouts;
        options = "grp:win_space_toggle";
      };
      numlock = true;
      repeat-delay = 275;
      repeat-rate = 35;
      track-layout = "window";
    };

    touchpad = {
      click-method = "button-areas";
      dwt = true;
      natural-scroll = true;
    };

    touch.map-to-output = "Lenovo Group Limited M14t V309WMZ3";

    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "0%";
    };

    warp-mouse-to-focus.enable = true;

  };

}
