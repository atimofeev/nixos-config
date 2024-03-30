{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ space-cadet-pinball ];
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
}
