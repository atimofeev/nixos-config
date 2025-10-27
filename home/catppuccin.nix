{ inputs, osConfig, ... }:
{

  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = true;
    inherit (osConfig.catppuccin) accent flavor;

    # NOTE: wait for 25.11
    # eza.enable = true;

    cursors.enable = false; # using adwaita cursors
    chromium.enable = false; # chromium is configured outside of home-manager
    gtk.icon.enable = false; # using adwaita icons
    hyprland.enable = false; # TODO: configure
    hyprlock.enable = false; # TODO: configure

  };

}
