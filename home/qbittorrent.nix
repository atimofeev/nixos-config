{ pkgs, config, ... }:
# adding qBittorrent into home-manager is not looking realistic without config overhaul by app devs
# hence there is a hacky solution for qBittorrent dotfiles
let
  # home directory is templated
  configSource = pkgs.writeText "qBittorrent.conf"
    (builtins.replaceStrings [ "{{HOME}}" ] [ config.home.homeDirectory ]
      (builtins.readFile ../assets/qBittorrent.conf));
  themeSource = ../assets/mocha.qbtheme;
in
{
  home.packages = with pkgs; [ qbittorrent ];
  xdg.configFile = {
    "qBittorrent/qBittorrent.conf".source = configSource;
    "qBittorrent/qBittorrent.conf".force = true; # overwrite destination file
    "qBittorrent/mocha.qbtheme".source = themeSource;
    "qBittorrent/mocha.qbtheme".force = true;
  };
}
