{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.hyprland-per-window-layout;
in
{

  options.custom-hm.services.hyprland-per-window-layout = {
    enable = lib.mkEnableOption "hyprland-per-window-layout bundle";
  };

  config = lib.mkIf cfg.enable {

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

  };

}
