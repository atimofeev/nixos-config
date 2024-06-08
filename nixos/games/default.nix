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
  ];

  programs = {
    gamemode = {
      enable = true; # gamemoderun %command% (?)
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true; # gamescope %command% (?)
    };
  };

}
