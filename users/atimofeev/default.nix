{

  imports = [

    ../../home/terminal
    ../../home/firefox

    ../../home/mpv.nix
    ../../home/obsidian.nix
    ../../home/qbittorrent.nix
    ../../home/swappy.nix
    ../../home/vcv-rack.nix
    ../../home/zathura.nix
    ../../home/zen-browser.nix

  ];

  custom-hm = {
    services = {
      cliphist.enable = true;
      dankmaterialshell.enable = true;
      hypridle.enable = false;
      hyprpanel.enable = false;
      hyprpaper.enable = false;
      hyprsunset.enable = false;
      polkit-gnome.enable = true;
      syncthing.enable = true;
      vicinae.enable = true;
    };
    system = {
      nix-index.enable = true;
    };
  };

}
