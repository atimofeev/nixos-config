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
  pkill = lib.getExe' pkgs.procps "pkill";
  playerctl = lib.getExe pkgs.playerctl;
  spotify_player = lib.getExe' pkgs.spotify-player "spotify_player";
  swappy = lib.getExe pkgs.swappy;
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";
  wtype = lib.getExe pkgs.wtype;
  yazi = lib.getExe pkgs.yazi;

  asus-switch-profile = pkgs.writeShellScript "asus-switch-profile" ''
    asusctl profile -n >/dev/null 2>&1
    name="$(asusctl profile -p | sed -n 's/.*Active profile is *//p')"
    notify-send -i power-profile-performance-symbolic "ASUS Profile" "$name"
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
    "Mod+A".action =
      spawn-sh ''${pkill} rofi || rofi -show drun -no-history -calc-command "echo -n '{result}' | ${wl-copy} && ${wtype} -M ctrl -P v -m ctrl -p v"'';
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
    "Mod+Shift+S".action.screenshot = {
      # write-to-disk = false;
      show-pointer = false;
    };

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

    # "Mod+1".action = focus-workspace 1;
    # "Mod+2".action = focus-workspace 2;
    # "Mod+3".action = focus-workspace 3;
    # "Mod+4".action = focus-workspace 4;
    # "Mod+5".action = focus-workspace 5;
    # "Mod+6".action = focus-workspace 6;
    # "Mod+7".action = focus-workspace 7;
    # "Mod+8".action = focus-workspace 8;
    # "Mod+9".action = focus-workspace 9;
    # "Mod+0".action = focus-workspace 10;

    # NOTE: won't build
    # "Mod+Ctrl+1".action = move-window-to-workspace 1;
    # "Mod+Ctrl+2".action = move-window-to-workspace 2;
    # "Mod+Ctrl+3".action = move-window-to-workspace 3;
    # "Mod+Ctrl+4".action = move-window-to-workspace 4;
    # "Mod+Ctrl+5".action = move-window-to-workspace 5;
    # "Mod+Ctrl+6".action = move-window-to-workspace 6;
    # "Mod+Ctrl+7".action = move-window-to-workspace 7;
    # "Mod+Ctrl+8".action = move-window-to-workspace 8;
    # "Mod+Ctrl+9".action = move-window-to-workspace 9;
    # "Mod+Ctrl+0".action = move-window-to-workspace 10;

  } // lib.mkIf config.custom-hm.services.vicinae {
      "Mod+Z".action = spawn-sh "vicinae toggle";
    };
}
