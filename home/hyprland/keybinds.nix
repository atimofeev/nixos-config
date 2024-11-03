{ pkgs, vars, ... }: {

  #TODO:
  # ags config on volume/brighness change
  # https://github.com/A7R7/hypr-config/blob/64da4c050740798bc890552f4fbb48cd4f2d7a30/hyprland.org?plain=1#L303
  wayland.windowManager.hyprland.settings = {

    # mouse
    bindm = [
      "SUPER, mouse:272, movewindow" # move floating windows with LMK
    ];

    # lock
    bindl = [
      ", xf86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
      ", xf86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
    ];

    # repeat
    binde = [
      # resize windows
      "SUPER SHIFT, left, resizeactive,-50 0"
      "SUPER SHIFT, right, resizeactive,50 0"
      "SUPER SHIFT, up, resizeactive,0 -50"
      "SUPER SHIFT, down, resizeactive,0 50"
    ];

    # lock + repeat
    bindle = [
      ", xf86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%- -q"
      ", xf86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+ -q"
    ];

    bind = [
      # apps
      "SUPER, Return, exec, ${vars.terminal.name}"
      "SUPER SHIFT, Return, exec, ${vars.terminal.name} -e ${vars.terminal.editor}"
      "SUPER, E, exec, ${vars.terminal.name} -e yazi"
      "SUPER SHIFT, H, exec, ${vars.terminal.name} -e btop"
      "SUPER SHIFT, N, exec, ${vars.terminal.name} -e nvtop"
      "SUPER SHIFT, S, exec, ${vars.terminal.name} -o term=xterm-kitty --class spotify_player -e spotify_player"
      "SUPER SHIFT, B, exec, firefox --new-window"

      ", xf86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # Make screenshots!
      ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
      "ALT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m window --clipboard-only"
      "SHIFT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output --clipboard-only"
      ", xf86Cut, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --raw | ${pkgs.swappy}/bin/swappy -f -" # region -> edit
      "SUPER, Print, exec, ${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.swappy}/bin/swappy -f -" # clipboard -> edit

      # Record screen!
      # wf-recorder
      # wf-recorder -g "$(slurp)"
      # wf-recorder --audio
      # wf-recorder -f "name.mp4"

      # media keys
      "CTRL SHIFT, N, exec, ${pkgs.playerctl}/bin/playerctl next"
      "CTRL SHIFT, P, exec, ${pkgs.playerctl}/bin/playerctl previous"
      "CTRL SHIFT, SPACE, exec, ${pkgs.playerctl}/bin/playerctl play-pause"

      # main
      "SUPER, Q, killactive" # or closewindow?
      "SUPER, F, fullscreen"
      "SUPER SHIFT, F, togglefloating"
      # "SUPER, `, exec, pkill rofi || ${pkgs.rofi}/bin/rofi -show run"

      # group
      "SUPER, G, togglegroup"
      "ALT, tab, changegroupactive"

      # move focus
      "SUPER, h, movefocus, l"
      "SUPER, j, movefocus, d"
      "SUPER, k, movefocus, u"
      "SUPER, l, movefocus, r"

      # move windows
      "SUPER CTRL, h, movewindow, l"
      "SUPER CTRL, j, movewindow, d"
      "SUPER CTRL, k, movewindow, u"
      "SUPER CTRL, l, movewindow, r"

      # workspaces
      "SUPER, page_up, workspace, m-1"
      "SUPER, page_down, workspace, m+1"
      "SUPER, bracketleft, workspace, -1"
      "SUPER, bracketright, workspace, +1"
      "SUPER, mouse_up, workspace, m+1"
      "SUPER, mouse_down, workspace, m-1"
      "SUPER, tab, workspace, previous"
      "SUPER SHIFT, U, movetoworkspace, special"
      "SUPER, U, togglespecialworkspace,"
      "SUPER SHIFT, page_up, movetoworkspace, -1"
      "SUPER SHIFT, page_down, movetoworkspace, +1"
      "SUPER CTRL, page_up, movetoworkspacesilent, -1"
      "SUPER CTRL, page_down, movetoworkspacesilent, +1"
      "SUPER SHIFT, bracketleft, movetoworkspace, -1"
      "SUPER SHIFT, bracketright, movetoworkspace, +1"
      "SUPER CTRL, bracketleft, movetoworkspacesilent, -1"
      "SUPER CTRL, bracketright, movetoworkspacesilent, +1"

      # 1..10 workspaces
    ] ++ (builtins.concatLists (builtins.genList (x:
      let
        ws = let c = builtins.div (x + 1) 10;
        in builtins.toString (x + 1 - (c * 10));
      in [
        "SUPER, ${ws}, workspace, ${toString (x + 1)}"
        "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        "SUPER CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
      ]) 10));

  };
}
