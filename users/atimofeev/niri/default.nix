{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
{

  imports = [

    inputs.niri-nix.homeModules.default

    ./animations.nix
    ./debug.nix
    ./gestures.nix
    ./input.nix
    ./keybinds.nix
    ./layout.nix
    ./outputs.nix
    ./window-rules.nix
    ./workspaces.nix

  ];

  home.packages = with pkgs; [
    libnotify
  ];

  custom-hm = {
    services.wayland-pipewire-idle-inhibit.enable = lib.mkDefault true;
    system = {
      gtk.enable = lib.mkDefault true;
      qt.enable = lib.mkDefault true;
    };
  };

  wayland.windowManager.niri = {
    inherit (osConfig.programs.niri) enable package;
    settings = {
      hotkey-overlay.skip-at-startup = { };
      overview.backdrop-color = "#1e1e2e";
      prefer-no-csd = { };
      screenshot-path = null;
    };
  };

}
