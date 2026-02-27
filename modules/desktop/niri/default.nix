{
  pkgs,
  vars,
  ...
}:
{

  home-manager.users.${vars.username} = import ./config;

  environment.systemPackages = [ pkgs.unstable.xwayland-satellite ];

  programs = {

    niri = {
      enable = true;
      useNautilus = false;
    };

    uwsm.waylandCompositors.niri = {
      prettyName = "Niri";
      comment = "A scrollable-tiling Wayland compositor";
      binPath = "/run/current-system/sw/bin/niri-session";
    };

  };

}
