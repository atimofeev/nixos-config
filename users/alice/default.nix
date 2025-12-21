{

  imports = [

    ../../home/terminal
    ../../home/firefox

    ../../home/zen-browser.nix

  ];

  custom-hm = {
    system = {
      nix-index.enable = true;
    };
  };

}
