{ pkgs, inputs, ... }:
let
  hyprlock = "${inputs.hyprlock.packages.${pkgs.system}.hyprlock}/bin/hyprlock";
  hypridle = "${inputs.hypridle.packages.${pkgs.system}.hypridle}/bin/hypridle";
in {

  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {

      general = {
        lock_cmd = "pidof hyprlock || ${hyprlock}";
        before_sleep_cmd = "loginctl lock-session && sleep 2";
        after_sleep_cmd =
          # "hyprctl dispatch dpms on && ${pkgs.brightnessctl}/bin/brightnessctl -s set 7500";
          # "systemctl --user restart hypridle.service && hyprctl dispatch dpms on";
          "(pkill hypridle || true) && (pidof hypridle || ${hypridle}) && hyprctl dispatch dpms on";
      };

      listener = [

        {
          timeout = 150; # 2.5min.
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 1000";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }

        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend";
        }

      ];

    };
  };

}
