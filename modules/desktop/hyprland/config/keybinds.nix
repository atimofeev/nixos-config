{
  config,
  lib,
  osConfig,
  pkgs,
  vars,
  ...
}:
let
  uwsm = lib.getExe pkgs.uwsm;
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";

  term = "${prefix} ${vars.terminal.name}";
  editor = "${vars.terminal.editor}";

  brightnessctl = lib.getExe pkgs.brightnessctl;
  btop = lib.getExe pkgs.btop;
  firefox = "firefox"; # NOTE: must use exe from user shell for custom policies to work
  grimblast = lib.getExe pkgs.grimblast;
  loginctl = lib.getExe' pkgs.elogind "loginctl";
  nvtop = lib.getExe' pkgs.nvtopPackages.full "nvtop";
  playerctl = lib.getExe pkgs.playerctl;
  spotify_player = lib.getExe' pkgs.spotify-player "spotify_player";
  swappy = lib.getExe pkgs.swappy;
  wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";
  yazi = lib.getExe pkgs.yazi;

  asus-switch-profile = pkgs.writeShellScript "asus-switch-profile" ''
    asusctl profile -n >/dev/null 2>&1
    name="$(asusctl profile -p | sed -n 's/.*Active profile is *//p')"
    notify-send -i power-profile-performance-symbolic "ASUS Profile" "$name"
  '';

  toggle-touchpad = pkgs.writeShellScript "toggle-touchpad" ''
    device="asuf1209:00-2808:0219-touchpad"
    state_file="/tmp/hypr-touchpad.state"

    if [ ! -f "$state_file" ]; then
      echo "on" > "$state_file"
    fi

    if grep -q "on" "$state_file"; then
      hyprctl keyword -r device[$device]:enabled false
      echo "off" > "$state_file"
      notify-send -i touchpad-disabled-symbolic "Touchpad disabled"
    else
      hyprctl keyword -r device[$device]:enabled true
      echo "on" > "$state_file"
      notify-send -i checkbox-checked-symbolic "Touchpad enabled"
    fi
  '';

in
{
  wayland.windowManager.hyprland.settings = {

    # mouse
    bindm = [
      "SUPER, mouse:272, movewindow" # move floating windows with SUPER+LMK
    ];

    # lock
    bindl = [
      ", xf86AudioLowerVolume, exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%- && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0"
      ", xf86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0"
      ", xf86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
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
      ", xf86MonBrightnessDown, exec, ${brightnessctl} -d intel_backlight set 5%- -q"
      ", xf86MonBrightnessUp, exec, ${brightnessctl} -d intel_backlight set 5%+ -q"
      ", xf86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set 33%- -q"
      ", xf86KbdBrightnessUp, exec, ${brightnessctl} -d asus::kbd_backlight set 33%+ -q"
    ];

    bind = [
      # apps
      "SUPER, Return, exec, ${term}"
      "SUPER SHIFT, Return, exec, ${term} -e ${editor}"
      "SUPER, E, exec, ${term} -e ${yazi}"
      "SUPER SHIFT, H, exec, ${term} -e ${btop}"
      "SUPER SHIFT, N, exec, ${term} -e ${nvtop}"
      "SUPER SHIFT, P, exec, ${term} -o term=xterm-kitty --class spotify_player -e ${spotify_player}"
      "SUPER SHIFT, B, exec, ${prefix} ${firefox} --new-window"
      "SUPER, V, exec, ${config.custom-hm.services.cliphist.command}"

      ", XF86TouchpadToggle, exec, ${toggle-touchpad}"
      ", XF86Launch4, exec, ${asus-switch-profile}"

      # Make screenshots!
      # https://github.com/hyprwm/contrib/issues/153
      ", Print, exec, GRIMBLAST_HIDE_CURSOR=0 ${grimblast} --notify --freeze copy area"
      "SUPER SHIFT, S, exec, GRIMBLAST_HIDE_CURSOR=0 ${grimblast} --notify --freeze save area - | ${swappy} -f -"
      ", xf86Cut, exec,  GRIMBLAST_HIDE_CURSOR=0 ${grimblast} --notify --freeze save area - | ${swappy} -f -"
      "SHIFT, Print, exec, GRIMBLAST_HIDE_CURSOR=0 ${grimblast} --notify --freeze copy output"
      "SUPER, Print, exec, ${wl-paste} | ${swappy} -f -"

      # Record screen!
      # wf-recorder
      # wf-recorder -g "$(slurp)"
      # wf-recorder --audio
      # wf-recorder -f "name.mp4"

      # main
      "SUPER, Q, killactive" # or closewindow?
      "SUPER, F, fullscreen"
      "SUPER SHIFT, F, togglefloating"
      "SUPER, P, pseudo" # dwindle layout
      "SUPER, S, togglesplit" # dwindle layout
      "SUPER SHIFT, L, exec, ${loginctl} lock-session"

      # group
      "SUPER, G, togglegroup"
      "ALT, tab, changegroupactive"
      "SUPER, tab, changegroupactive"

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
      "SUPER, bracketleft, workspace, r-1"
      "SUPER, bracketright, workspace, r+1"
      "SUPER ALT, h, workspace, m-1"
      "SUPER ALT, l, workspace, m+1"
      "SUPER, mouse_up, workspace, m+1"
      "SUPER, mouse_down, workspace, m-1"
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
    ]
    ++ (builtins.concatLists (
      builtins.genList (
        x:
        let
          ws =
            let
              c = builtins.div (x + 1) 10;
            in
            builtins.toString (x + 1 - (c * 10));
        in
        [
          "SUPER, ${ws}, workspace, ${toString (x + 1)}"
          "SUPER CTRL, ${ws}, movetoworkspace, ${toString (x + 1)}"
          "SUPER SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
        ]
      ) 10
    ));

  };
}
