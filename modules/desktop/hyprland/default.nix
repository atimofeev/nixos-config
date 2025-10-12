{
  pkgs,
  lib,
  vars,
  ...
}:
{

  home-manager.users.${vars.username} = import ./config;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # wayland for electron apps
    # NOTE: https://github.com/NixOS/nixpkgs/issues/353990
    GSK_RENDERER = "cairo";
  };

  services = {
    dbus.implementation = "broker";

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            "--cmd 'uwsm start Hyprland'"
            "--asterisks"
            "--remember"
            "--remember-user-session"
            ''
              --greeting "Hey you. You're finally awake."

            ''
          ];
          user = "greeter";
        };
      };
    };

  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
