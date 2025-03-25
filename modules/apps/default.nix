{ pkgs, ... }: {

  imports = [ ./chromium.nix ];

  environment.systemPackages = with pkgs; [
    # GUI/TUI apps
    emacs29
    vscode
    firefox
    telegram-desktop
    spotify

    # fun
    lolcat
    pipes
    cmatrix
    tmatrix
    neo
    cbonsai
    lavat

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
