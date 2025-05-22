{ pkgs, config, ... }:
# adding qBittorrent into home-manager is not looking realistic without config overhaul by app devs
# hence there is a hacky solution for qBittorrent dotfiles
let
  themeName = "macchiato.qbtheme";

  configSource = pkgs.writeText "qBittorrent.conf" (
    builtins.replaceStrings
      [ "{{HOME}}" "{{THEME}}" ]
      [
        config.home.homeDirectory
        themeName
      ]
      (builtins.readFile ../assets/qBittorrent.conf)
  );

  themeSource =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "qbittorrent";
      rev = "c2fa170731a17644a6f93d4d8fc4614426488c62";
      sha256 = "sha256-j9QqhT5oiYZp7CJVZmUvJvwtoKNYAxJKmzLpy8KsCZs=";
    }
    + "/${themeName}"; # path to theme in repo

in
{
  home.packages = with pkgs; [ qbittorrent ];
  xdg.configFile = {
    "qBittorrent/qBittorrent.conf" = {
      force = true; # overwrite destination file
      source = configSource;
    };
    "qBittorrent/${themeName}" = {
      force = true;
      source = themeSource;
    };
  };
}
