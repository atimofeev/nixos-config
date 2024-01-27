{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    firefox
    telegram-desktop
    spotify-player
    prusa-slicer
  ];
}
