{ inputs, pkgs, lib, vars, ... }: {

  imports = [ ./hyprpanel.nix ];

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
            "--cmd Hyprland"
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # NOTE: may be redundant
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wayland/hyprland.nix
  xdg.portal = {
    enable = true;
    configPackages = lib.mkDefault
      [ inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = [ "hyprland" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
  };

}
