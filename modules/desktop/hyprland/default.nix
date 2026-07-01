{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.hyprland;
in
{

  options.custom.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop bundle";
    withUWSM = lib.mkOption {
      default = true;
      description = "Enable UWSM integration for Hyprland.";
      type = lib.types.bool;
    };
    xwayland = {
      enable = lib.mkOption {
        default = true;
        description = "Enable XWayland for Hyprland.";
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      AQ_DRM_DEVICES = "/dev/dri/igpu:/dev/dri/dgpu";
      GSK_RENDERER = "cairo"; # NOTE: https://github.com/NixOS/nixpkgs/issues/353990
      NIXOS_OZONE_WL = "1"; # wayland for electron apps
    };

    programs.hyprland = {
      enable = true;
      inherit (cfg) withUWSM;
      xwayland.enable = cfg.xwayland.enable;
    };

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

}
