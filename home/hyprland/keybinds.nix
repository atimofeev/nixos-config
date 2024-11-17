{ pkgs, inputs, vars, ... }:
let
  term = "${vars.terminal.name}";
  editor = "${vars.terminal.editor}";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  hyprpanel = "${pkgs.hyprpanel}/bin/hyprpanel";
  hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  swappy = "${pkgs.swappy}/bin/swappy";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in {

  # TODO:
  # ags config on volume/brighness change
  # https://github.com/A7R7/hypr-config/blob/64da4c050740798bc890552f4fbb48cd4f2d7a30/hyprland.org?plain=1#L303
  wayland.windowManager.hyprland.settings = {

    # mouse
    bindm = [
      "SUPER, mouse:272, movewindow" # move floating windows with SUPER+LMK
    ];

    # lock
    bindl = [
      ", xf86AudioLowerVolume, exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
      ", xf86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", xf86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioPause, exec, ${playerctl} play-pause"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      ", XF86AudioNext, exec, ${playerctl} next"
      "CTRL SHIFT, N, exec, ${playerctl} next"
      "CTRL SHIFT, P, exec, ${playerctl} previous"
      "CTRL SHIFT, SPACE, exec, ${playerctl} play-pause"
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
      ", xf86MonBrightnessDown, exec, ${brightnessctl} set 5%- -q"
      ", xf86MonBrightnessUp, exec, ${brightnessctl} set 5%+ -q"
    ];

    bind = [
      # apps
      "SUPER, Return, exec, ${term}"
      "SUPER SHIFT, Return, exec, ${term} -e ${editor}"
      "SUPER, E, exec, ${term} -e yazi"
      "SUPER SHIFT, H, exec, ${term} -e btop"
      "SUPER SHIFT, N, exec, ${term} -e nvtop"
      "SUPER SHIFT, S, exec, ${term} -o term=xterm-kitty --class spotify_player -e spotify_player"
      "SUPER SHIFT, B, exec, firefox --new-window"

      # Make screenshots!
      ", Print, exec, ${hyprshot} -m region --clipboard-only"
      "ALT, Print, exec, ${hyprshot} -m window --clipboard-only"
      "SHIFT, Print, exec, ${hyprshot} -m output --clipboard-only"
      ", xf86Cut, exec, ${hyprshot} -m region --raw | ${swappy} -f -" # region -> edit
      "SUPER, Print, exec, ${wl-paste} | ${swappy} -f -" # clipboard -> edit

      # Record screen!
      # wf-recorder
      # wf-recorder -g "$(slurp)"
      # wf-recorder --audio
      # wf-recorder -f "name.mp4"

      # main
      "SUPER, Q, killactive" # or closewindow?
      "SUPER, F, fullscreen"
      "SUPER SHIFT, F, togglefloating"
      "SUPER, P, pseudo" # dwindle
      "SUPER, S, togglesplit" # dwindle
      # "SUPER, `, exec, pkill rofi || ${pkgs.rofi}/bin/rofi -show run"
      "SUPER, A, exec, pkill hyprlauncher || ${pkgs.hyprlauncher}/bin/hyprlauncher"
      "SUPER, B, exec, pkill .ags-wrapped || ${hyprpanel}"
      "SUPER SHIFT, L, exec, ${pkgs.elogind}/bin/loginctl lock-session"

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
      "SUPER CTRL, page_up, movetoworkspace, -1"
      "SUPER CTRL, page_down, movetoworkspace, +1"
      "SUPER SHIFT, page_up, movetoworkspacesilent, -1"
      "SUPER SHIFT, page_down, movetoworkspacesilent, +1"
      "SUPER CTRL, bracketleft, movetoworkspace, -1"
      "SUPER CTRL, bracketright, movetoworkspace, +1"
      "SUPER SHIFT, bracketleft, movetoworkspacesilent, -1"
      "SUPER SHIFT, bracketright, movetoworkspacesilent, +1"

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
