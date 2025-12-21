{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.applications.games;
in
{
  imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

  options.custom.applications.games = {
    enable = lib.mkEnableOption "games bundle";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      lutris
      wine
      winetricks
      protonup-qt

      # tools
      mangohud # mangohud %command%
      moonlight-qt

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
    };

  };

}
