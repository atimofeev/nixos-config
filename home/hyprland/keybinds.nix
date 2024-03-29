{ vars, ... }: {

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      # apps
      "$mod, Return, exec, ${vars.terminal.name}"
      "$mod SHIFT, Return, exec, ${vars.terminal.name} -e ${vars.terminal.editor}"
      "$mod SHIFT, H, exec, ${vars.terminal.name} -e htop"

      # laptop fn keys
      # ", xf86audiomute, exec, $scriptsDir/Volume.sh --toggle"
      # ", xf86audiolowervolume, exec, $scriptsDir/Volume.sh --dec" # volume down
      # ", xf86audioraisevolume, exec, $scriptsDir/Volume.sh --inc" # volume up
      # ", xf86KbdBrightnessDown, exec, $scriptsDir/BrightnessKbd.sh --dec" # Keyboard brightness Down
      # ", xf86KbdBrightnessUp, exec, $scriptsDir/BrightnessKbd.sh --inc" # Keyboard brightness up

      # Make screenshots!
      # https://www.youtube.com/watch?v=J1L1qi-5dr0
      # depends on: grim, slurp, wl-clipboard, swappy
      # "scissorsLaptopButtonF7, exec, grim -t png -g "$(slurp)" - | wl-copy"
      # "printScreenLaptopButtonF11, exec, grim -t png - | wl-copy"
      # "SHIFT, scissorsLaptopButtonF7, exec, grim -t png -g "$(slurp)" - | swappy -f -"
      # "SOMEKEY, exec, wl-paste | swappy -f -" # edit clipboard image

      # Record screen!
      # wf-recorder
      # wf-recorder -g "$(slurp)"
      # wf-recorder --audio
      # wf-recorder -f "name.mp4"

      ", xf86Sleep, exec, systemctl suspend" # sleep button

      # main
      "$mod, Q, killactive" # or closewindow?
      "$mod SHIFT, F, fullscreen"
      "$mod, F, togglefloating"
      "$mod ALT, F, exec, hyprctl dispatch workspaceopt allfloat"

      # group
      "$mod, G, togglegroup"
      "ALT, tab, changegroupactive"

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
