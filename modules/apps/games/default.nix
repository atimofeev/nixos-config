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
    dwarf-fortress
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

  hardware.xone.enable = true;

}