{ pkgs, vars, ... }: {
  # TODO: retroarch https://nixos.wiki/wiki/RetroArch
  # ballance game
  environment.systemPackages = with pkgs; [
    # virt
    playonlinux
    # games
    space-cadet-pinball
  ];

  programs = {
    # TODO: configure
    gamemode = {
      enable = true; # gamemoderun %command% (?)
      # settings = { };
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true; # gamescope %command% (?)
      # platformOptimizations.enable = true; TODO: install https://github.com/fufexan/nix-gaming
    };
  };

  # FIX: xone-dongle module is not launched on dongle insert
  # https://github.com/NixOS/nixpkgs/issues/308028
  hardware.xone.enable = true;
}
