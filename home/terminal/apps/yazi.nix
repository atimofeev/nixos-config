{ pkgs, config, ... }:
let
  themeName = "catppuccin-macchiato-blue.toml";

  themeSource = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "54d868433a0c2f3e1651114136ea088eef72a4a7";
    sha256 = "sha256-dMXSXS3Scj1LZZqqnvvC37VWSyjSQZg9thvjcm2iNSM=";
  } + "/themes/macchiato/${themeName}"; # path to theme in repo

in {

  programs.yazi = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  xdg.configFile."yazi/theme.toml".source = themeSource;
}
