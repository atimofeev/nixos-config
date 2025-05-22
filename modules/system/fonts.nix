{ pkgs, ... }:
{

  fonts.packages = [
    pkgs.nerd-fonts.dejavu-sans-mono
    pkgs.nerd-fonts.jetbrains-mono # Hyprpanel
  ];

}
