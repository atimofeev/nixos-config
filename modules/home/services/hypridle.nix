{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.hypridle;

  uwsm = lib.getExe pkgs.uwsm;
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";

  brightnessctl = lib.getExe pkgs.brightnessctl;
  hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
  hyprlock = lib.getExe pkgs.hyprlock;
  swaylock = lib.getExe pkgs.swaylock;
  pidof = lib.getExe' pkgs.procps "pidof";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  systemd-ac-power = lib.getExe' pkgs.systemd "systemd-ac-power";

  lockCommand =
    if config.programs.hyprlock.enable then
      "(${pidof} hyprlock || ${prefix} ${hyprlock} --grace 10)"
    else if config.programs.swaylock.enable then
      "(${pidof} swaylock || ${prefix} ${swaylock})"
    else
      ":";
  suspend-command =
    if osConfig.custom.hardware.power.hibernate then "suspend-then-hibernate" else "suspend";

in
{

  options.custom-hm.services.hypridle = {
    enable = lib.mkEnableOption "hypridle bundle";
  };

  config = lib.mkIf cfg.enable {

    # NOTE: https://github.com/hyprwm/hypridle/issues/129
    systemd.user.services.hypridle.Service.StandardOutput = "null";

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
            timeout = 60 * 2.5;
            on-timeout = "${systemd-ac-power} && ${brightnessctl} -d intel_backlight -s set 15%";
            on-resume = "${systemd-ac-power} && ${brightnessctl} -d intel_backlight -r";
          }

          {
            timeout = 60 * 5;
            on-timeout = "${systemd-ac-power} && ${lockCommand}";
          }

          {
            timeout = 60 * 5.5;
            on-timeout = "${systemd-ac-power} && ${hyprctl} dispatch dpms off && ${brightnessctl} -d asus::kbd_backlight -s set 0%";
            on-resume = "${systemd-ac-power} && ${hyprctl} dispatch dpms on && ${brightnessctl} -d asus::kbd_backlight -s set 33%";
          }

          {
            timeout = 60 * 10;
            on-timeout = "${systemd-ac-power} && ${systemctl} ${suspend-command}";
          }

          # ON BATTERY
          {
            timeout = 60;
            on-timeout = "${systemd-ac-power} || ${brightnessctl} -d intel_backlight -s set 15%";
            on-resume = "${systemd-ac-power} || ${brightnessctl} -d intel_backlight -r";
          }

          {
            timeout = 60 * 2.5;
            on-timeout = "${systemd-ac-power} || ${lockCommand}";
          }

          {
            timeout = 60 * 3;
            on-timeout = "${systemd-ac-power} || { ${hyprctl} dispatch dpms off && ${brightnessctl} -d asus::kbd_backlight -s set 0%; }";
            on-resume = "${systemd-ac-power} || { ${hyprctl} dispatch dpms on && ${brightnessctl} -d asus::kbd_backlight -s set 33%; }";
          }

          {
            timeout = 60 * 4;
            on-timeout = "${systemd-ac-power} || ${systemctl} ${suspend-command}";
          }

        ];

      };
    };

  };

}
