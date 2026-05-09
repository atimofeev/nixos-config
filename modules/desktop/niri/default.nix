{ pkgs, ... }:
{

  environment.systemPackages = [ pkgs.unstable.xwayland-satellite ];

  programs = {

    niri = {
      enable = true;
      package = pkgs.unstable.niri;
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
