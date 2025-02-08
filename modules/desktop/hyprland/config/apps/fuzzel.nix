{ pkgs, osConfig, vars, ... }:
let
  uwsm = "${pkgs.uwsm}/bin/uwsm";
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";

  themeName = "catppuccin-macchiato/blue.ini";
  themeSource = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fuzzel";
    rev = "0af0e26901b60ada4b20522df739f032797b07c3";
    sha256 = "sha256-XpItMGsYq4XvLT+7OJ9YRILfd/9RG1GMuO6J4hSGepg=";
  } + "/themes/${themeName}"; # path to theme in repo
in {
  programs.fuzzel = {
    enable = true;
    settings.main = {
      include = "${themeSource}";
      dpi-aware = false;
      terminal = "${vars.terminal.name} -e";
      launch-prefix = prefix;
    };
  };
}
