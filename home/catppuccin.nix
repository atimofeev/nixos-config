{
  config,
  inputs,
  osConfig,
  pkgs,
  ...
}:
{

  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = true;
    inherit (osConfig.catppuccin) accent flavor;

    # NOTE: wait for 25.11
    # eza.enable = true;

    chromium.enable = false; # chromium is configured outside of home-manager
    cursors.enable = false; # using adwaita cursors
    gtk.icon.enable = false; # using adwaita icons
    hyprland.enable = false; # TODO: configure
    hyprlock.enable = false; # not using colors
    spotify-player.enable = false; # default theme looks better in themed terminal

    # NOTE: override mpv backgroud
    # https://github.com/catppuccin/nix/issues/468
    sources.mpv =
      inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.mpv.overrideAttrs
        (oldAttrs: {
          postPatch = (oldAttrs.postPach or "") + ''
            substituteInPlace "themes/${config.catppuccin.mpv.flavor}/${config.catppuccin.mpv.accent}.conf" \
              --replace-fail "background-color='#1e1e2e'" "background-color='#000000'"
          '';
        });

  };

}
