{ pkgs, ... }:
{

  imports = [ ./chromium.nix ];

  environment.systemPackages = with pkgs; [
    # GUI/TUI apps
    emacs
    vscode
    firefox
    telegram-desktop
    spotify

    # typing
    keypunch
    gtypist

    # misc
    prusa-slicer
    freecad
    openscad
    upscayl
    eyedropper # pick colors
    parabolic # download video & audio
    # alpaca # chat with local LLMs
  ];

}
