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
      vicinae.enable = true;
      polkit-gnome.enable = true;
      syncthing.enable = true;
    };
    system = {
      nix-index.enable = true;
    };
  };

}
