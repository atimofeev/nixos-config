{
  pkgs,
  lib,
  vars,
  ...
}:
{

  home-manager.users.${vars.username} = import ./config;

  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/dri/igpu:/dev/dri/dgpu";
    GSK_RENDERER = "cairo"; # NOTE: https://github.com/NixOS/nixpkgs/issues/353990
    NIXOS_OZONE_WL = "1"; # wayland for electron apps
  };

  services = {
    dbus.implementation = "broker";

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${lib.getExe pkgs.tuigreet}"
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

  # NOTE: prevent systemd messages appearing on top of greetd
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
