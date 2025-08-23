{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  uwsm = "${pkgs.uwsm}/bin/uwsm";
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";

  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  # hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  pidof = "${pkgs.procps}/bin/pidof";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  systemd-ac-power = "${pkgs.systemd}/bin/systemd-ac-power";

  lockCommand =
    if config.programs.hyprlock.enable then
      "(${pidof} hyprlock || ${prefix} ${hyprlock})"
    else if config.programs.swaylock.enable then
      "(${pidof} swaylock || ${prefix} ${swaylock})"
    else
      ":";

in
{

  wayland.windowManager.hyprland.settings = {
    misc = {
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {

      general = {
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        lock_cmd = lockCommand;
        before_sleep_cmd = lockCommand;
        after_sleep_cmd = "${hyprctl} dispatch dpms on";
      };

      listener = [

        # # TEST
        # {
        #   timeout = 3;
        #   on-timeout = "notify-send timeout";
        #   on-resume = "notify-send resume";
        # }

        # ON AC
        {
          timeout = 150; # 2.5min
          on-timeout = "${systemd-ac-power} && ${brightnessctl} -s set 1000";
          on-resume = "${systemd-ac-power} && ${brightnessctl} -r";
        }

        {
          timeout = 300; # 5min
          on-timeout = "${systemd-ac-power} && ${lockCommand}";
        }

        {
          timeout = 330; # 5.5min
          on-timeout = "${systemd-ac-power} && ${hyprctl} dispatch dpms off";
          on-resume = "${systemd-ac-power} && ${hyprctl} dispatch dpms on";
        }

        {
          timeout = 1800; # 30min
          on-timeout = "${systemd-ac-power} && ${systemctl} suspend";
        }

        # ON BATTERY
        {
          timeout = 60; # 1min
          on-timeout = "${systemd-ac-power} || ${brightnessctl} -s set 1000";
          on-resume = "${systemd-ac-power} || ${brightnessctl} -r";
        }

        {
          timeout = 130; # 2.5min
          on-timeout = "${systemd-ac-power} || ${lockCommand}";
        }

        {
          timeout = 160; # 3min
          on-timeout = "${systemd-ac-power} || ${hyprctl} dispatch dpms off";
          on-resume = "${systemd-ac-power} || ${hyprctl} dispatch dpms on";
        }

        {
          timeout = 600; # 10min
          on-timeout = "${systemd-ac-power} || ${systemctl} suspend";
        }

      ];

    };
  };

}
