{ vars, ... }: {

  wayland.windowManager.hyprland.settings = {

    input = {

      kb_layout = vars.kb_layouts;
      kb_options = "grp:win_space_toggle";
      repeat_rate = 35;
      repeat_delay = 275;
      numlock_by_default = true;
      sensitivity = -0.1;
      accel_profile = "adaptive";

      touchpad = { natural_scroll = 1; };

    };

    gestures = {
      workspace_swipe = 1;
      workspace_swipe_create_new = false;
      # workspace_swipe_fingers = 3;
      # workspace_swipe_distance = 900;
      # workspace_swipe_invert = 1;
      # workspace_swipe_min_speed_to_force = 30;
      # workspace_swipe_cancel_ratio = 0.5;
      # workspace_swipe_forever = false;
    };

  };
}
