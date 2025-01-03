{ pkgs, ... }: {

  systemd.user.services.hyprland-per-window-layout = {
    Unit.Description = "hyprland-per-window-layout";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart =
        "${pkgs.hyprland-per-window-layout}/bin/hyprland-per-window-layout";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      # environment = "HPWX_PREFER_FIRST=true";
    };
  };

}
