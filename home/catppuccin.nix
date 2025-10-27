{ inputs, osConfig, ... }:
{

  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    inherit (osConfig.catppuccin) accent flavor;
    # NOTE: wait for 25.11
    # eza.enable = true;
    atuin.enable = true;
    bat.enable = true;
    btop.enable = true;
    cursors.enable = false; # I use adwaita cursors
    chromium.enable = false; # chromium is configured outside of home-manager
    firefox.enable = true;
    fish.enable = true;
    fzf.enable = true;
    hyprland.enable = false; # TODO: configure
    hyprlock.enable = false; # TODO: configure
    k9s.enable = true;
    kitty.enable = true;
    kvantum.enable = true; # qt
    mpv.enable = true;
    nushell.enable = true;
    nvim.enable = true;
    rofi.enable = true;
    spotify-player.enable = true;
    starship.enable = false; # TODO: configure
    yazi.enable = true;
    zathura.enable = true;
  };

}
