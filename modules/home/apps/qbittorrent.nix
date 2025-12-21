{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.qbittorrent;
  themeName = "macchiato.qbtheme";

  configSource = pkgs.writeText "qBittorrent.conf" (
    builtins.replaceStrings
      [ "{{HOME}}" "{{THEME}}" ]
      [
        config.home.homeDirectory
        themeName
      ]
      (builtins.readFile ./qBittorrent.conf)
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

  options.custom-hm.applications.qbittorrent = {
    enable = lib.mkEnableOption "qbittorrent bundle";
    package = lib.mkPackageOption pkgs "qbittorrent" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
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
  };

}
