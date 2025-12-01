{ lib, ... }:
{

  services.hyprsunset = {
    enable = true;
    settings.profile = [
      {
        time = "8:30";
        identity = true;
      }
      {
        time = "22:00";
        temperature = "5000";
        gamma = 0.8;
      }
    ];
  };

  systemd.user.services.hyprsunset = {
    Install = {
      WantedBy = lib.mkForce [ "wayland-wm@Hyprland.service" ];
    };
    Unit = {
      After = lib.mkForce [ "wayland-wm@Hyprland.service" ];
      PartOf = lib.mkForce [ "wayland-wm@Hyprland.service" ];
      StartLimitBurst = 5;
      StartLimitIntervalSec = 120;
    };
  };

}
