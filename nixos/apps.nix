{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # GUI/TUI apps
    firefox
    telegram-desktop
    spotify-player
    qbittorrent

    # fun
    lolcat
    pipes
    cmatrix
    tmatrix

    # misc
    prusa-slicer
  ];
}
