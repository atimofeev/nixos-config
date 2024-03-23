{ pkgs-unstable, ... }: {
  # TODO: https://github.com/catppuccin/spotify-player
  home.packages = with pkgs-unstable; [ spotify-player ];

}
