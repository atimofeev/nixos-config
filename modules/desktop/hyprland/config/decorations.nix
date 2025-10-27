let
  acolor1 = "rgb(c6a0f6)"; # #c6a0f6
  acolor2 = "rgb(b7bdf8)"; # #b7bdf8
  acolor3 = "rgb(8aadf4)"; # #8aadf4
  icolor1 = "rgb(5b6078)"; # #5b6078
  tcolor = "rgb(000000)"; # #000000
  active_border = "${acolor1} ${acolor2} ${acolor3} 30deg";
  inactive_border = "${icolor1}";
in
{
  wayland.windowManager.hyprland.settings = {

    general = {
      gaps_in = 2;
      gaps_out = 3;
      border_size = 3;

      "col.active_border" = active_border;
      "col.inactive_border" = inactive_border;
    };

    group = {
      "col.border_active" = active_border;
      "col.border_inactive" = inactive_border;
      groupbar = {
        "col.active" = acolor2;
        "col.inactive" = icolor1;
        font_size = 12;
        gradient_rounding = 0;
        gradients = true;
        height = 11;
        keep_upper_gap = false;
        rounding = 0;
        text_color = tcolor;
        text_offset = -2;
      };
    };

    decoration = {
      rounding = 3;
      inactive_opacity = 0.9;
      dim_special = 0.35;
      shadow.enabled = false;
      blur.enabled = false;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };

  };
}
