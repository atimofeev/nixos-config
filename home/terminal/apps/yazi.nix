{ pkgs, ... }:
let
  themeName = "catppuccin-macchiato-blue.toml";

  themeSource = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "54d868433a0c2f3e1651114136ea088eef72a4a7";
    sha256 = "sha256-dMXSXS3Scj1LZZqqnvvC37VWSyjSQZg9thvjcm2iNSM=";
  } + "/themes/macchiato/${themeName}"; # path to theme in repo

in {

  programs.yazi.enable = true;

  xdg.configFile."yazi/theme.toml".source = themeSource;
}
