{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  uwsm = lib.getExe pkgs.uwsm;
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";

  term = "${prefix} ${config.custom-hm.user.terminal}";
  inherit (config.custom-hm.user) editor launcher;

  brightnessctl = lib.getExe pkgs.brightnessctl;
  btop = lib.getExe config.custom-hm.applications.btop.package;
  browser-exe = "zen-beta"; # NOTE: must use exe from user shell for custom policies to work
  loginctl = lib.getExe' pkgs.elogind "loginctl";
  nvtop = lib.getExe' pkgs.nvtopPackages.full "nvtop";
  spotify_player = lib.getExe' config.programs.spotify-player.package "spotify_player";
  swappy = lib.getExe pkgs.swappy;
  wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";
  yazi = lib.getExe pkgs.yazi;

  asus-switch-profile = pkgs.writeShellScript "asus-switch-profile" ''
    asusctl profile next
    name="$(asusctl profile get | sed -n 's/.*Active profile: //p')"
    notify-send -i power-profile-performance-symbolic "$name" "ASUS Profile"
  '';

  # toggle-touchpad = pkgs.writeShellScript "toggle-touchpad" ''
  #   device="asuf1209:00-2808:0219-touchpad"
  #   state_file="/tmp/hypr-touchpad.state"
  #
  #   if [ ! -f "$state_file" ]; then
  #     echo "on" > "$state_file"
  #   fi
  #
  #   if grep -q "on" "$state_file"; then
  #     hyprctl keyword -r device[$device]:enabled false
  #     echo "off" > "$state_file"
  #     notify-send -i touchpad-disabled-symbolic "Touchpad disabled"
  #   else
  #     hyprctl keyword -r device[$device]:enabled true
  #     echo "on" > "$state_file"
  #     notify-send -i checkbox-checked-symbolic "Touchpad enabled"
  #   fi
  # '';
in
{

  wayland.windowManager.niri.settings.binds = {

    # apps
    "Mod+Return".spawn-sh = "${term}";
    "Mod+Shift+Return".spawn-sh = "${term} -e ${editor}";
    "Mod+E".spawn-sh = "${term} -e ${yazi}";
    "Mod+Shift+H".spawn-sh = "${term} -e ${btop}";
    "Mod+Shift+N".spawn-sh = "${term} -e ${nvtop}";
    "Mod+Shift+P".spawn-sh = "${term} -o term=xterm-kitty --class spotify_player -e ${spotify_player}";
    "Mod+Shift+B".spawn = [
      browser-exe
      "--new-window"
    ];
    "Mod+A" = lib.mkIf (launcher.command != null) { spawn-sh = launcher.command; };
    "Mod+V" = lib.mkIf (launcher.clipboard-cmd != null) { spawn-sh = launcher.clipboard-cmd; };
    "Mod+D" = lib.mkIf (launcher.web-search-cmd != null) { spawn-sh = launcher.web-search-cmd; };

    # media keys
    "XF86AudioLowerVolume".spawn-sh =
      "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%- && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
    "XF86AudioRaiseVolume".spawn-sh =
      "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
    "XF86AudioMute".spawn = [
      wpctl
      "set-mute"
      "@DEFAULT_AUDIO_SINK@"
      "toggle"
    ];
    "XF86AudioMicMute".spawn = [
      wpctl
      "set-mute"
      "@DEFAULT_AUDIO_SOURCE@"
      "toggle"
    ];
    "XF86AudioPlay".spawn = [
      "dms"
      "ipc"
      "mpris"
      "playPause"
    ];
    "XF86AudioPause".spawn = [
      "dms"
      "ipc"
      "mpris"
      "playPause"
    ];
    "XF86AudioNext".spawn = [
      "dms"
      "ipc"
      "mpris"
      "next"
    ];
    "XF86AudioPrev".spawn = [
      "dms"
      "ipc"
      "mpris"
      "previous"
    ];
    "Ctrl+Shift+N".spawn = [
      "dms"
      "ipc"
      "mpris"
      "next"
    ];
    "Ctrl+Shift+P".spawn = [
      "dms"
      "ipc"
      "mpris"
      "previous"
    ];
    "Ctrl+Shift+Space".spawn = [
      "dms"
      "ipc"
      "mpris"
      "playPause"
    ];
    # "XF86TouchpadToggle".spawn-sh = "${toggle-touchpad}";
    "XF86Launch4".spawn = [ "${asus-switch-profile}" ];
    "XF86MonBrightnessDown".spawn = [
      brightnessctl
      "-d"
      "intel_backlight"
      "set"
      "5%-"
      "-q"
    ];
    "XF86MonBrightnessUp".spawn = [
      brightnessctl
      "-d"
      "intel_backlight"
      "set"
      "5%+"
      "-q"
    ];
    "XF86KbdBrightnessDown".spawn = [
      brightnessctl
      "-d"
      "asus::kbd_backlight"
      "set"
      "33%-"
      "-q"
    ];
    "XF86KbdBrightnessUp".spawn = [
      brightnessctl
      "-d"
      "asus::kbd_backlight"
      "set"
      "33%+"
      "-q"
    ];

    # main
    "Mod+Q" = {
      _props.repeat = false;
      close-window = { };
    };
    "Mod+O".toggle-overview = { };
    "Mod+F".fullscreen-window = { };
    "Mod+R".switch-preset-column-width = { };
    "Mod+Shift+R".switch-preset-window-height = { };
    "Mod+Shift+F".toggle-window-floating = { };
    "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
    "Mod+Comma".consume-window-into-column = { };
    "Mod+Period".expel-window-from-column = { };
    "Mod+Shift+L".spawn = [
      loginctl
      "lock-session"
    ];
    "Mod+U".spawn-sh =
      ''niri msg workspaces | grep "\\*.*special" && niri msg action focus-workspace-previous || niri msg action focus-workspace special'';

    # screen capture
    "Print".screenshot._props = {
      # write-to-disk = false;
      show-pointer = false;
    };
    "Ctrl+Print".screenshot-screen._props = {
      write-to-disk = false;
      show-pointer = false;
    };
    "Alt+Print".screenshot-window._props = {
      write-to-disk = false;
      show-pointer = false;
    };
    "Mod+Shift+S".spawn-sh = "niri msg action screenshot && ${wl-paste} | ${swappy} -f - ";
    "Mod+Print".spawn-sh = "${wl-paste} | ${swappy} -f -";

    # focus and movement
    "Mod+H".focus-column-left = { };
    "Mod+J".focus-window-or-workspace-down = { };
    "Mod+K".focus-window-or-workspace-up = { };
    "Mod+L".focus-column-right = { };

    "Mod+Ctrl+H".move-column-left = { };
    "Mod+Ctrl+J".move-window-down-or-to-workspace-down = { };
    "Mod+Ctrl+K".move-window-up-or-to-workspace-up = { };
    "Mod+Ctrl+L".move-column-right = { };

    "Mod+BracketLeft".focus-monitor-left = { };
    "Mod+BracketRight".focus-monitor-right = { };
    "Mod+Alt+H".focus-monitor-left = { };
    "Mod+Alt+L".focus-monitor-right = { };

    "Mod+Ctrl+BracketLeft".move-window-to-monitor-left = { };
    "Mod+Ctrl+BracketRight".move-window-to-monitor-right = { };
    "Mod+Ctrl+Alt+H".move-window-to-monitor-left = { };
    "Mod+Ctrl+Alt+L".move-window-to-monitor-right = { };

    "Mod+WheelScrollDown".focus-window-or-workspace-down = { };
    "Mod+WheelScrollUp".focus-window-or-workspace-up = { };
    "Mod+WheelScrollRight".focus-column-right = { };
    "Mod+WheelScrollLeft".focus-column-left = { };

  };
}
