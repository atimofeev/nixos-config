{ pkgs, ... }: {

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit.Description = "polkit-gnome-authentication-agent-1";
    Install.WantedBy = [ "hyprland-session.target" ];
    Service = {
      Type = "simple";
      ExecStart =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "stayfocused, class:polkit-gnome-authentication-agent-1"
    "dimaround, class:polkit-gnome-authentication-agent-1"
    "noanim, class:polkit-gnome-authentication-agent-1"
  ];

}
