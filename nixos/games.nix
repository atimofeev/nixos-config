{ pkgs, vars, ... }: {
  environment.systemPackages = with pkgs; [
    # virt
    playonlinux
    # games
    space-cadet-pinball
  ];

  programs.steam = {
    enable = true;
    # platformOptimizations.enable = true; # TODO: install https://github.com/fufexan/nix-gaming
  };

  hardware.steam-hardware.enable = true;
}
