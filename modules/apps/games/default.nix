{ inputs, pkgs, ... }: {

  imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

  environment.systemPackages = with pkgs; [
    lutris
    wine
    winetricks
    protonup-qt

    # tools
    mangohud # mangohud %command%

    # games
    space-cadet-pinball
  ];

  programs = {
    gamemode = {
      enable = true; # gamemoderun %command% (?)
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true; # separate DE
      platformOptimizations.enable = true; # nix-gaming
      protontricks.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

  hardware = {
    steam-hardware.enable = true;
    xone.enable = true;
    firmware = [ pkgs.xow_dongle-firmware-045e_02e6 ];
  };

}
