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
      # FIX: nautilus is required for screensharing
      # https://github.com/niri-wm/niri/issues/544
      # useNautilus = false;
    };

    uwsm.waylandCompositors.niri = {
      prettyName = "Niri";
      comment = "A scrollable-tiling Wayland compositor";
      binPath = "/run/current-system/sw/bin/niri-session";
    };

  };

}
