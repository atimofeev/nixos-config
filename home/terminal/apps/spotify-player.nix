{ pkgs, ... }:
{

  programs.spotify-player = {
    enable = true;
    package = pkgs.unstable.spotify-player;
    settings = {
      liked_icon = "";
      device = {
        volume = 85;
        autoplay = true;
      };
    };
  };

}
