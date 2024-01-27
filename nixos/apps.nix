{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    firefox
    telegram-desktop
    spotify-player
    qbittorrent
    prusa-slicer
  ];
}
