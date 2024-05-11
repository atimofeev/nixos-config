_: {
  programs.waybar.settings = {
    "mainBar" = {
      # Modules
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

      "clock" = {
        format = "{:%d %b %H:%M}";
        tooltip-format = ''
          <big>{:%Y %B}</big>
          <tt><small>{calendar}</small></tt>'';
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#f5c2e7'><b>{}</b></span>";
            days = "<span color='#cdd6f4'><b>{}</b></span>";
            weeks = "<span color='#cba6f7'><b>T{:%U}</b></span>";
            weekdays = "<span color='#eba0ac'><b>{}</b></span>";
            today = "<span color='#a6e3a1'><b><u>{}</u></b></span>";
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
      };

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

      # "bluetooth" = { };
      #
      # "clock" = { };
      #
      # "hyprland/language" = { };
      #
      # "hyprland/window" = { };
      #
      # "idle_inhibitor" = { };
      #
      # "keyboard-state" = { };
      #
      # "mpris" = { };
      #
      # "network" = { };
      #
      # "pulseaudio" = { };
      #
      # "temperature" = { };
      #
      # "tray" = { };
      #
      # "wireplumber" = { };

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
  };
}
