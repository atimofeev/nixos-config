{ vars, ... }: {

  wayland.windowManager.hyprland.settings.input = {

    kb_layout = vars.kb_layouts;
    kb_options = "grp:win_space_toggle";
    repeat_rate = 35;
    repeat_delay = 275;
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

}
