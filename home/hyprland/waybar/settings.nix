{ ... }: {
  # TODO: make it following format:
  # left: workspaces
  # center: 22 Feb 14:58 (click: notifications + calendar)
  # right: en  wifi bluetooth sound battery

  programs.waybar = {
    settings = {
      "bar" = {
        layer = "top";
        mode = "dock";
        # "mode": "dock"; # Uncomment and adjust as necessary
        exclusive = true;
        passthrough = false;
        position = "top";
        spacing = 3;
        fixed-center = true;
        ipc = true;
        margin-top = 3;
        margin-left = 8;
        margin-right = 8;
        modules-left = [
          "hyprland/workspaces#pacman"
          "custom/separator#dot-line"
          "cpu"
          "custom/separator#dot-line"
          "temperature"
          "custom/separator#dot-line"
          "memory"
          "custom/separator#dot-line"
          "custom/weather"
          "custom/separator#blank_3"
          "custom/cava_mviz"
        ];
        modules-center = [
          "custom/menu"
          "custom/separator#dot-line"
          "idle_inhibitor"
          "custom/separator#dot-line"
          "clock"
          "custom/separator#dot-line"
          "custom/light_dark"
          "custom/separator#dot-line"
          "custom/lock"
          # "custom/separator#dot-line", # Uncomment as needed
          "custom/keybinds"
        ];
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
