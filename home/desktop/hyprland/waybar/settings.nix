_: {
  # TODO: make it following format:
  # left: workspaces
  # center: 22 Feb 14:58 (click: notifications + calendar)
  # right: en  wifi bluetooth sound battery

  programs.waybar = {
    settings = {
      "mainBar" = {
        layer = "top";
        mode = "dock";
        exclusive = true;
        passthrough = false;
        position = "top";
        spacing = 3;
        fixed-center = true;
        ipc = true;
        margin-top = 1;
        margin-left = 1;
        margin-right = 1;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "network#speed"
          "custom/separator#dot-line"
          "custom/swaync"
          "tray"
          "mpris"
          "custom/separator#dot-line"
          "bluetooth"
          "custom/separator#dot-line"
          "pulseaudio"
          "custom/separator#dot-line"
          "pulseaudio#microphone"
          "custom/separator#dot-line"
          "keyboard-state"
          "custom/separator#dot-line"
          "custom/keyboard"
          "custom/separator#dot-line"
          "custom/power"
        ];
      };
    };
  };
}
