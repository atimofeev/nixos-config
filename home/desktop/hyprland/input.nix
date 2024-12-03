{ vars, ... }: {
  wayland.windowManager.hyprland.settings = {

    general.sensitivity = 1.0;

    input = {
      accel_profile = "adaptive";
      kb_layout = vars.kb_layouts;
      kb_options = "grp:win_space_toggle";
      numlock_by_default = true;
      repeat_delay = 275;
      repeat_rate = 35;
      sensitivity = -0.1;

      touchpad.natural_scroll = 1;
    };

    gestures = {
      workspace_swipe = 1;
      workspace_swipe_create_new = false;
    };

  };
}
