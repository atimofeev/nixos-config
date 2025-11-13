{
  lib,
  pkgs,
  ...
}:
{

  systemd.user.services.hyprland-per-window-layout = {
    Unit = {
      Description = "hyprland-per-window-layout";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
      StartLimitBurst = 5;
      StartLimitIntervalSec = 120;
    };

    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.hyprland-per-window-layout;
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

}
