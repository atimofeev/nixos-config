{ vars, ... }: {

  wayland.windowManager.hyprland.settings = {

    monitor = "eDP-1,1920x1080@60,0x0,1";

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
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      resize_on_border = true;

      col.active_border = "$color0 $color2 $color4 $color6 $color8 90deg";
      col.inactive_border = "$backgroundCol";

      layout = "master";
    };

    group = {
      col.border_active = "$color15";

      groupbar = { col.active = "$color0"; };
    };

    decoration = {
      rounding = 8;

      active_opacity = 1.0;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1.0;

      dim_inactive = true;
      dim_strength = 0.1;

      drop_shadow = true;
      shadow_range = 6;
      shadow_render_power = 1;
      col.shadow = "$color2";
      col.shadow_inactive = "0x50000000";

      blur = {
        enabled = true;
        size = 5;
        passes = 2;
        ignore_opacity = true;
        new_optimizations = true;
      };
    };

    animations = {
      enabled = "yes";
      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
        "linear, 0.0, 0.0, 1.0, 1.0"
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "slow, 0, 0.85, 0.3, 1"
        "overshot, 0.7, 0.6, 0.1, 1.1"
        "bounce, 1.1, 1.6, 0.1, 0.85"
        "sligshot, 1, -1, 0.15, 1.25"
        "nice, 0, 6.9, 0.5, -4.20"
      ];
      animation = [
        "windowsIn, 1, 5, slow, popin"
        "windowsOut, 1, 5, winOut, popin"
        "windowsMove, 1, 5, wind, slide"
        "border, 1, 10, linear"
        "borderangle, 1, 180, linear, loop" # used by rainbow borders and rotating colors
        "fade, 1, 5, overshot"
        "workspaces, 1, 5, wind"
        "windows, 1, 5, bounce, popin"
      ];

    };

    input = {
      kb_layout = vars.kb_layouts;
      kb_options = "grp:win_space_toggle";
      repeat_rate = 50;
      repeat_delay = 300;
      numlock_by_default = 1;
      left_handed = 0;
      follow_mouse = 1;
      float_switch_override_focus = 0;

      touchpad = {
        disable_while_typing = 1;
        natural_scroll = 1;
        clickfinger_behavior = 0;
        middle_button_emulation = 1;
        tap-to-click = 1;
        drag_lock = 0;
      };
    };

    gestures = {
      workspace_swipe = 1;
      workspace_swipe_fingers = 3;
      workspace_swipe_distance = 400;
      workspace_swipe_invert = 1;
      workspace_swipe_min_speed_to_force = 30;
      workspace_swipe_cancel_ratio = 0.5;
      workspace_swipe_create_new = 1;
      workspace_swipe_forever = 1;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      #vrr = 0;
      enable_swallow = true;
      no_direct_scanout = true; # for fullscreen games
      focus_on_activate = false;
      swallow_regex = "^(kitty)$";
      #disable_autoreload = true;
    };

    binds = {
      workspace_back_and_forth = 1;
      allow_workspace_cycles = 1;
      pass_mouse_when_bound = 0;
    };

    #Could help when scaling and not pixelating
    xwayland.force_zero_scaling = true;
  };
}
