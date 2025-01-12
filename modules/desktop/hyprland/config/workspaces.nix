_: {
  wayland.windowManager.hyprland.settings = {

    workspace = [
      "1, monitor:eDP-1, default:yes"
      "2, monitor:eDP-1"
      "3, monitor:eDP-1"
      "4, monitor:eDP-1"
      "5, monitor:HDMI-A-1, default:yes"
      "6, monitor:HDMI-A-1"
      "7, monitor:HDMI-A-1"
      "8, monitor:HDMI-A-1"
      "9, monitor:HDMI-A-1"
      "10, monitor:DP-1, default:yes"
      "11, monitor:DP-1"
      "12, monitor:DP-1"
      "13, monitor:DP-1"
      "14, monitor:DP-1"
    ];

    binds = {
      # NOTE: no effect
      workspace_back_and_forth = false;
      allow_workspace_cycles = false;
      movefocus_cycles_fullscreen = false;
    };

  };
}
