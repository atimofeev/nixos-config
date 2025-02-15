{ inputs, pkgs, lib, vars, ... }: {

  nixpkgs.overlays = [ inputs.hyprpanel.overlay ];

  # Dependencies
  services = {
    gvfs.enable = lib.mkDefault true;
    power-profiles-daemon.enable = lib.mkDefault true;
    upower.enable = lib.mkDefault true;
  };

  home-manager.users.${vars.username} = {

    wayland.windowManager.hyprland.settings.bind =
      let systemctl = "${pkgs.systemd}/bin/systemctl";
      in [
        # "SUPER, B, exec, ${systemctl} --user is-active hyprpanel && ${systemctl} --user stop hyprpanel || ${systemctl} --user start hyprpanel"
        "SUPER, B, exec, ${systemctl} --user restart hyprpanel"
      ];

    systemd.user.services.hyprpanel = {
      Unit = {
        Description = "hyprpanel";
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

  };

}
