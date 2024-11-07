{ vars, ... }:
let
  acolor1 = "rgb(c6a0f6)"; # #c6a0f6
  acolor2 = "rgb(8aadf4)"; # #8aadf4
  icolor1 = "rgb(5b6078)"; # #5b6078
  active_border = "${acolor1} ${acolor2} 45deg";
  inactive_border = "${icolor1}";
in {

  wayland.windowManager.hyprland.settings = {

    monitor = [
      "desc:BOE 0x0747, preferred, 0x0, 1"
      "desc:Dell Inc. DELL P2422H 8WRR0V3, preferred, 1920x0, 1"
      "desc:Dell Inc. DELL P2422H 6FZG7N3, preferred, auto, 1"
      "desc:Lenovo Group Limited M14t V309WMZ3, preferred, auto, 1.2"
    ];

    dwindle = {
      pseudotile = "yes";
      preserve_split = "yes";
      special_scale_factor = 0.85;
      force_split = 2;
    };

    master = {
      new_is_master = 1;
      new_on_top = 1;
      mfact = 0.5;
    };

    general = {
      sensitivity = 1.0;
      apply_sens_to_raw = 1;
      gaps_in = 2;
      gaps_out = 3;
      border_size = 2;
      resize_on_border = true;

      "col.active_border" = active_border;
      "col.inactive_border" = inactive_border;

      # layout = "master";
      layout = "dwindle";
    };

    group = {

      "col.border_active" = active_border;
      "col.border_inactive" = inactive_border;

      groupbar = {
        text_color = "rgb(000000)";
        "col.active" = acolor1;
        "col.inactive" = icolor1;
      };

    };

    decoration = {
      rounding = 4;

      active_opacity = 1.0;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1.0;

      # dim_inactive = true;
      # dim_strength = 0.1;

      drop_shadow = false;
      # shadow_range = 6;
      # shadow_render_power = 1;

      blur = {
        enabled = false;
        # size = 5;
        # passes = 2;
        # ignore_opacity = true;
        # new_optimizations = true;
      };
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      #vrr = 0;
      enable_swallow = true;
      no_direct_scanout = true; # for fullscreen games
      focus_on_activate = true;
      swallow_regex = "^(${vars.terminal.name})$";
    };

    binds = { pass_mouse_when_bound = 0; };

    #Could help when scaling and not pixelating
    xwayland.force_zero_scaling = true;

  };
}
