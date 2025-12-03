{

  imports = [

    ../../home/terminal
    ../../home/firefox

    ../../home/catppuccin.nix
    ../../home/mpv.nix
    ../../home/nix-index.nix
    ../../home/obsidian.nix
    ../../home/qbittorrent.nix
    ../../home/slack.nix
    ../../home/sops.nix
    ../../home/swappy.nix
    ../../home/vcv-rack.nix
    ../../home/zathura.nix
    ../../home/zen-browser.nix

  ];

  custom-hm = {
    services = {
      cliphist.enable = true;
      syncthing.enable = true;
    };
  };

}
