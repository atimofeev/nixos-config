{ vars, ... }: {

  wayland.windowManager.hyprland.settings = {

    monitor = [ "eDP-1,1920x1080@60,0x0,1" "DP-1,1920x1080@60,1920x0,1.2" ];

    dwindle = {
      pseudotile = "yes";
      preserve_split = "yes";
      special_scale_factor = 0.8;
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

      # col.active_border = "#c6a0f6";
      # col.inactive_border = "$backgroundCol";

      # layout = "master";
      layout = "dwindle";
    };

    decoration = {
      rounding = 4;

      active_opacity = 1.0;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1.0;

      # dim_inactive = true;
      # dim_strength = 0.1;

      drop_shadow = true;
      shadow_range = 6;
      shadow_render_power = 1;

      blur = {
        enabled = true;
        size = 5;
        passes = 2;
        ignore_opacity = true;
        new_optimizations = true;
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
