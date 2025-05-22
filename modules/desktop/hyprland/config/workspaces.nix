_: {
  wayland.windowManager.hyprland.settings = {

    workspace =
      let
        monitors = [
          # order matters
          "HDMI-A-1"
          "eDP-1"
          "DP-1"
        ];
      in
      [
        "1, monitor:${builtins.elemAt monitors 0}, default:yes"
        "2, monitor:${builtins.elemAt monitors 0}"
        "3, monitor:${builtins.elemAt monitors 0}"
        "4, monitor:${builtins.elemAt monitors 0}"
        "5, monitor:${builtins.elemAt monitors 1}, default:yes"
        "6, monitor:${builtins.elemAt monitors 1}"
        "7, monitor:${builtins.elemAt monitors 1}"
        "8, monitor:${builtins.elemAt monitors 1}"
        "9, monitor:${builtins.elemAt monitors 1}"
        "10, monitor:${builtins.elemAt monitors 2}, default:yes"
        "11, monitor:${builtins.elemAt monitors 2}"
        "12, monitor:${builtins.elemAt monitors 2}"
        "13, monitor:${builtins.elemAt monitors 2}"
        "14, monitor:${builtins.elemAt monitors 2}"
      ];

    binds = {
      # NOTE: no effect
      workspace_back_and_forth = false;
      allow_workspace_cycles = false;
      movefocus_cycles_fullscreen = false;
    };

  };
}
