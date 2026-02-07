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
  inherit (config.custom-hm.user) editor;

  brightnessctl = lib.getExe pkgs.brightnessctl;
  btop = lib.getExe config.custom-hm.applications.btop.package;
  firefox = "firefox"; # NOTE: must use exe from user shell for custom policies to work
  loginctl = lib.getExe' pkgs.elogind "loginctl";
  nvtop = lib.getExe' pkgs.nvtopPackages.full "nvtop";
  playerctl = lib.getExe pkgs.playerctl;
  spotify_player = lib.getExe' pkgs.spotify-player "spotify_player";
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

  programs.niri.settings.binds = with config.lib.niri.actions; {

    # apps
    "Mod+Return".action = spawn-sh "${term}";
    "Mod+Shift+Return".action = spawn-sh "${term} -e ${editor}";
    "Mod+E".action = spawn-sh "${term} -e ${yazi}";
    "Mod+Shift+H".action = spawn-sh "${term} -e ${btop}";
    "Mod+Shift+N".action = spawn-sh "${term} -e ${nvtop}";
    "Mod+Shift+P".action =
      spawn-sh "${term} -o term=xterm-kitty --class spotify_player -e ${spotify_player}";
    "Mod+Shift+B".action = spawn-sh "${term} -e ${firefox} --new-window";
    "Mod+A".action = spawn-sh config.custom-hm.user.launcher.command;
    "Mod+V".action = spawn-sh config.custom-hm.services.cliphist.command;

    # media keys
    "XF86AudioLowerVolume".action =
      spawn-sh "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%- && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
    "XF86AudioRaiseVolume".action =
      spawn-sh "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
    "XF86AudioMute".action = spawn-sh "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "XF86AudioMicMute".action = spawn-sh "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    "XF86AudioPlay".action = spawn-sh "${playerctl} play-pause";
    "XF86AudioPause".action = spawn-sh "${playerctl} play-pause";
    "XF86AudioPrev".action = spawn-sh "${playerctl} previous";
    "XF86AudioNext".action = spawn-sh "${playerctl} next";
    "Ctrl+Shift+N".action = spawn-sh "${playerctl} next";
    "Ctrl+Shift+P".action = spawn-sh "${playerctl} previous";
    "Ctrl+Shift+Space".action = spawn-sh "${playerctl} play-pause";
    # "XF86TouchpadToggle".action = spawn-sh "${toggle-touchpad}";
    "XF86Launch4".action = spawn-sh "${asus-switch-profile}";
    "XF86MonBrightnessDown".action = spawn-sh "${brightnessctl} -d intel_backlight set 5%- -q";
    "XF86MonBrightnessUp".action = spawn-sh "${brightnessctl} -d intel_backlight set 5%+ -q";
    "XF86KbdBrightnessDown".action = spawn-sh "${brightnessctl} -d asus::kbd_backlight set 33%- -q";
    "XF86KbdBrightnessUp".action = spawn-sh "${brightnessctl} -d asus::kbd_backlight set 33%+ -q";

    # main
    "Mod+Q" = {
      action = close-window;
      repeat = false;
    };
    "Mod+O".action = toggle-overview;
    "Mod+F".action = fullscreen-window;
    "Mod+R".action = switch-preset-column-width;
    "Mod+Shift+R".action = switch-preset-window-height;
    "Mod+Shift+F".action = toggle-window-floating;
    "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
    "Mod+Shift+L".action = spawn-sh "${loginctl} lock-session";
    "Mod+U".action =
      spawn-sh ''niri msg workspaces | grep "\*.*special" && niri msg action focus-workspace-previous || niri msg action focus-workspace special'';

    # screen capture
    "Print".action.screenshot = {
      # write-to-disk = false;
      show-pointer = false;
    };
    "Ctrl+Print".action.screenshot-screen = {
      write-to-disk = false;
      show-pointer = false;
    };
    "Alt+Print".action.screenshot-window = {
      # write-to-disk = false;
      # show-pointer = false;
    };
    "Mod+Shift+S".action = spawn-sh "niri msg action screenshot && ${wl-paste} | ${swappy} -f - ";
    "Mod+Print".action = spawn-sh "${wl-paste} | ${swappy} -f -";

    # focus and movement
    "Mod+H".action = focus-column-left;
    "Mod+J".action = focus-window-or-workspace-down;
    "Mod+K".action = focus-window-or-workspace-up;
    "Mod+L".action = focus-column-right;

    "Mod+Ctrl+H".action = move-column-left;
    "Mod+Ctrl+J".action = move-window-down-or-to-workspace-down;
    "Mod+Ctrl+K".action = move-window-up-or-to-workspace-up;
    "Mod+Ctrl+L".action = move-column-right;

    "Mod+BracketLeft".action = focus-monitor-left;
    "Mod+BracketRight".action = focus-monitor-right;
    "Mod+Alt+H".action = focus-monitor-left;
    "Mod+Alt+L".action = focus-monitor-right;

    "Mod+Ctrl+BracketLeft".action = move-window-to-monitor-left;
    "Mod+Ctrl+BracketRight".action = move-window-to-monitor-right;
    "Mod+Ctrl+Alt+H".action = move-window-to-monitor-left;
    "Mod+Ctrl+Alt+L".action = move-window-to-monitor-right;

    "Mod+WheelScrollDown".action = focus-window-or-workspace-down;
    "Mod+WheelScrollUp".action = focus-window-or-workspace-up;
    "Mod+WheelScrollRight".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;

  };
}
