{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # GUI/TUI apps
    emacs29
    vscode
    firefox
    telegram-desktop

    # fun
    lolcat
    pipes
    cmatrix
    tmatrix

    # misc
    prusa-slicer
    vcv-rack
  ];
}
