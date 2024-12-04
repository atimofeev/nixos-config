{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    # GUI/TUI apps
    emacs29
    vscode
    firefox
    telegram-desktop
    obsidian
    spotify

    # fun
    lolcat
    pipes
    cmatrix
    tmatrix

    # misc
    prusa-slicer
    freecad
    openscad
    upscayl
    eyedropper # pick colors
    parabolic # download video & audio
    keypunch
    alpaca
  ];

}
