{
  pkgs,
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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
