{ vars, ... }: {

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$term" = vars.terminal.name;

    bind = [
      # apps
      "$mod, Return, exec, $term"
      "$mod SHIFT, H, exec, kitty -e htop"

      # main
      "$mod, Q, killactive" # or closewindow?
      "$mod SHIFT, F, fullscreen"
      "$mod, F, togglefloating"
      "$mod ALT, F, exec, hyprctl dispatch workspaceopt allfloat"

      # move focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # move windows
      "$mod CTRL, left, movewindow, l"
      "$mod CTRL, right, movewindow, r"
      "$mod CTRL, up, movewindow, u"
      "$mod CTRL, down, movewindow, d"

      # bar
      "$mod, B, exec, killall -SIGUSR1 waybar" # toggle waybar

      # workspaces
      "$mod, tab, workspace, m+1"
      "$mod SHIFT, tab, workspace, m-1"
      "$mod SHIFT, U, movetoworkspace, special"
      "$mod, U, togglespecialworkspace,"
      "$mod SHIFT, bracketleft, movetoworkspace, -1"
      "$mod SHIFT, bracketright, movetoworkspace, +1"
      "$mod CTRL, bracketleft, movetoworkspacesilent, -1"
      "$mod CTRL, bracketright, movetoworkspacesilent, +1"

      # 1..10 workspaces
    ] ++ (builtins.concatLists (builtins.genList
      (x:
        let
          ws =
            let c = builtins.div (x + 1) 10;
            in builtins.toString (x + 1 - (c * 10));
        in
        [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          "$mod CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
        ]) 10));

    # these KB will repeat on hold
    binde = [
      # resize windows
      "$mod SHIFT, left, resizeactive,-50 0"
      "$mod SHIFT, right, resizeactive,50 0"
      "$mod SHIFT, up, resizeactive,0 -50"
      "$mod SHIFT, down, resizeactive,0 50"
    ];

  };
}