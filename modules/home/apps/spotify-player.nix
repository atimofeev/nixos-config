{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.spotify-player;
in
{

  options.custom-hm.applications.spotify-player = {
    enable = lib.mkEnableOption "spotify-player bundle";
    package = lib.mkPackageOption pkgs "spotify-player" { };
  };

  config = lib.mkIf cfg.enable {
    programs.spotify-player = {
      enable = true;
      inherit (cfg) package;
      settings = {
        liked_icon = "";
        device = {
          volume = 85;
          autoplay = true;
        };
      };
    };
  };

}
