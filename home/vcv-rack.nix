{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [ vcv-rack ];

  # TODO: source settings and patches
  # git clone git@github.com:atimofeev/vcv-rack2-settings.git $HOME/repos/vcv-rack2-settings/
  # git clone git@github.com:atimofeev/vcv-rack2-patches.git $HOME/repos/vcv-rack2-patches/
  # symlinks:
  # SRC=DEST
  # $HOME/repos/vcv-rack2-settings/=$HOME/.Rack2
  # $HOME/repos/vcv-rack2-patches/=$HOME/.Rack2/patches
}
