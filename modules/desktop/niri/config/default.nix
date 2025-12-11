{
  inputs,
  lib,
  pkgs,
  ...
}:
{

  imports = [

    inputs.niri.homeModules.niri

    ./gestures.nix
    ./input.nix
    ./keybinds.nix
    ./layout.nix
    ./outputs.nix
    ./window-rules.nix
    ./workspaces.nix

  ];

  custom-hm.services = {
    wayland-pipewire-idle-inhibit.enable = lib.mkDefault true;
  };

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
