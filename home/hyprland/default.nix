{ inputs, pkgs, vars, ... }:
# TODO: apply colors:
# https://github.com/catppuccin/hyprland
# https://github.com/catppuccin/waybar
# https://github.com/catppuccin/rofi
# https://github.com/catppuccin/dunst
# https://github.com/catppuccin/sddm
# https://github.com/catppuccin/swaylock
# https://github.com/catppuccin/gtk
# https://github.com/catppuccin/cursors

{

  imports = [
    ./animations.nix
    ./hyprcursor.nix
    ./hyprpaper.nix
    ./input.nix
    ./keybinds.nix
    ./settings.nix
    ./window-rules.nix
    ./workspaces.nix
  ];

  # home.packages = with pkgs; [
  #   sddm # display manager
  #   dunst # notifications
  #   libnotify
  # ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {

      exec-once = [ "${pkgs.hyprpanel}/bin/hyprpanel" ];

    };
  };

}
