{ pkgs, vars, ... }: {

  #TODO:
  # ags config on volume/brighness change
  # https://github.com/A7R7/hypr-config/blob/64da4c050740798bc890552f4fbb48cd4f2d7a30/hyprland.org?plain=1#L303
  wayland.windowManager.hyprland.settings = {

    bind = [
      # apps
      "SUPER, Return, exec, ${vars.terminal.name}"
      "SUPER SHIFT, Return, exec, ${vars.terminal.name} -e ${vars.terminal.editor}"
      "SUPER, E, exec, ${vars.terminal.name} -e yazi"
      "SUPER SHIFT, H, exec, ${vars.terminal.name} -e htop"
      "SUPER SHIFT, N, exec, ${vars.terminal.name} -e nvtop"
      "SUPER SHIFT, B, exec, firefox --new-window"

      # laptop special keys
      ", xf86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", xf86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", xf86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", xf86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%- -q"
      ", xf86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+ -q"

      # Make screenshots!
      ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
      "ALT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m window --clipboard-only"
      "SHIFT, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output --clipboard-only"
      ", Cut, exec, ${pkgs.hyprshot}/bin/hyprshot -m region --raw | ${pkgs.swappy}/bin/swappy -f -" # region -> edit
      "SUPER, Print, exec, ${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.swappy}/bin/swappy -f -" # clipboard -> edit

      # Record screen!
      # wf-recorder
      # wf-recorder -g "$(slurp)"
      # wf-recorder --audio
      # wf-recorder -f "name.mp4"

      # main
      "SUPER, Q, killactive" # or closewindow?
      "SUPER, F, fullscreen"
      "SUPER SHIFT, F, togglefloating"
      "SUPER ALT, F, exec, hyprctl dispatch workspaceopt allfloat"

      # group
      "SUPER, G, togglegroup"
      "ALT, tab, changegroupactive"

      # move focus
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      # move windows
      "SUPER CTRL, left, movewindow, l"
      "SUPER CTRL, right, movewindow, r"
      "SUPER CTRL, up, movewindow, u"
      "SUPER CTRL, down, movewindow, d"

      # bar
      "SUPER, B, exec, killall -SIGUSR1 waybar" # toggle waybar

      # workspaces
      "SUPER, tab, workspace, m+1"
      "SUPER SHIFT, tab, workspace, m-1"
      "SUPER SHIFT, U, movetoworkspace, special"
      "SUPER, U, togglespecialworkspace,"
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

    # these KB will repeat on hold
    binde = [
      # resize windows
      "SUPER SHIFT, left, resizeactive,-50 0"
      "SUPER SHIFT, right, resizeactive,50 0"
      "SUPER SHIFT, up, resizeactive,0 -50"
      "SUPER SHIFT, down, resizeactive,0 50"
    ];

  };
}
