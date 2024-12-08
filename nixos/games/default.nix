{ pkgs, ... }: {
  imports = [ ./xone.nix ];

  environment.systemPackages = with pkgs; [
    # virt
    lutris
    wine
    winetricks

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
      gamescopeSession.enable = true; # gamescope %command% (?)
      platformOptimizations.enable = true; # nix-gaming
      protontricks.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

}
