{ pkgs, vars, ... }: {
  environment.systemPackages = with pkgs; [
    # virt
    playonlinux

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

  hardware.xone.enable = true;
}
