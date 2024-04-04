{ pkgs, vars, ... }: {
  environment.systemPackages = with pkgs; [
    # soft
    razergenie
    # virt
    playonlinux
    # games
    space-cadet-pinball
  ];

  programs.steam = {
    enable = true;
    # platformOptimizations.enable = true; # TODO: install https://github.com/fufexan/nix-gaming
  };
  hardware = {
    steam-hardware.enable = true;

    openrazer = {
      enable = true;
      users = [ vars.username ];
      mouseBatteryNotifier = true;
    };
  };
}
