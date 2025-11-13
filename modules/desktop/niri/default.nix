{
  inputs,
  pkgs,
  vars,
  ...
}:
{

  # imports = [ inputs.niri.nixosModules.niri ];

  home-manager.users.${vars.username} = import ./config;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.uwsm.waylandCompositors.niri = {
    prettyName = "Niri";
    comment = "A scrollable-tiling Wayland compositor";
    binPath = "/run/current-system/sw/bin/niri-session";
  };

}
