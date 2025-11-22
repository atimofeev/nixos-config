{
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    inputs.niri.homeModules.niri

    # TODO: enable in 25.11
    # ./dankmaterialshell.nix
    ./input.nix
    ./keybinds.nix
    ./layout.nix
    ./outputs.nix
    ./window-rules.nix
    ./workspaces.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      debug.honor-xdg-activation-with-invalid-serial = { };
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      screenshot-path = null;
      xwayland-satellite.enable = true;
    };
  };

}
