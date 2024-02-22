{ ... }: {
  programs.waybar.settings = {

    # Workspaces
    "hyprland/workspaces" = {
      active-only = false;
      all-outputs = true;
      format = "{icon}";
      show-special = false;
      on-click = "activate";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";
      persistent-workspaces = {
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
        "5" = [ ];
      };
      format-icons = {
        active = "";
        default = "";
      };
    };

    # Modules
    "backlight" = {
      interval = 2;
      align = 0;
      rotate = 0;
      format = "{icon}";
      format-icons =
        [ "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ];
      tooltip-format = "backlight {percent}%";
      icon-size = 10;
      on-click = "";
      on-click-middle = "";
      on-click-right = "";
      on-update = "";
      on-scroll-up = ""; # script to increase brightness
      on-scroll-down = ""; # script to decrease brightness
      smooth-scrolling-threshold = 1;
    };

    # TODO: steal icons from gnome
    "battery" = {
      interval = 5;
      align = 0;
      rotate = 0;
      full-at = 100;
      design-capacity = false;
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = "{capacity}%";
      format-plugged = "󱘖{capacity}%";
      format-alt-click = "click";
      format-full = "{icon} Full";
      format-alt = "{icon} {time}";
      format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      format-time = "{H}h {M}min";
      tooltip = true;
      tooltip-format = "{timeTo} {power}w";
      on-click-middle = "~/.config/hypr/scripts/ChangeBlur.sh";
      on-click-right = "~/.config/hypr/scripts/Wlogout.sh";
    };

    # TODO: finish copying /home/atimofeev/Downloads/Fedora-Hyprland/JaKooLit-Hyprland-Dots/config/waybar/modules
    "bluetooth" = { };

    "clock" = { };

    "cpu" = { };

    "disk" = { };

    "hyprland/language" = { };

    "hyprland/window" = { };

    "idle_inhibitor" = { };

    "keyboard-state" = { };

    "memory" = { };

    "mpris" = { };

    "network" = { };

    "network#speed" = { };

    "pulseaudio" = { };

    "pulseaudio#microphone" = { };

    "temperature" = { };

    "tray" = { };

    "wireplumber" = { };

    # Custom Modules

    # Custom Separators
    "custom/separator#dot" = {
      format = "";
      interval = "once";
      tooltip = false;
    };

    "custom/separator#dot-line" = {
      format = "";
      interval = "once";
      tooltip = false;
    };

    "custom/separator#line" = {
      format = "|";
      interval = "once";
      tooltip = false;
    };

    "custom/separator#blank" = {
      format = "";
      interval = "once";
      tooltip = false;
    };

    "custom/separator#blank_2" = {
      format = "  ";
      interval = "once";
      tooltip = false;
    };

    "custom/separator#blank_3" = {
      format = "   ";
      interval = "once";
      tooltip = false;
    };

  };
}
