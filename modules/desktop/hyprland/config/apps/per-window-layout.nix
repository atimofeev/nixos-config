{
  lib,
  pkgs,
  ...
}:
{

  systemd.user.services.hyprland-per-window-layout = {
    Unit = {
      Description = "hyprland-per-window-layout";
      After = "wayland-wm@Hyprland.service";
      PartOf = "wayland-wm@Hyprland.service";
      StartLimitBurst = 5;
      StartLimitIntervalSec = 120;
    };

    Install.WantedBy = [ "wayland-wm@Hyprland.service" ];
    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.hyprland-per-window-layout;
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

}
