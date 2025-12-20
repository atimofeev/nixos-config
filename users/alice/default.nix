{

  imports = [

    ../../home/terminal
    ../../home/firefox

    ../../home/obsidian.nix
    ../../home/qbittorrent.nix
    ../../home/zen-browser.nix

  ];

  custom-hm = {
    system = {
      nix-index.enable = true;
    };
  };

}
