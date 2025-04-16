{ pkgs, ... }:
let
  themeName = "catppuccin-macchiato.yaml";
  themeSource = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "590a762110ad4b6ceff274265f2fe174c576ce96";
    sha256 = "sha256-EBDciL3F6xVFXvND+5duT+OiVDWKkFMWbOOSruQ0lus=";
  } + "/dist/${themeName}"; # path to theme in repo
in {

  imports = [ ./plugins ];

  programs.k9s = {
    enable = true;
    package = pkgs.unstable.k9s;

    settings.k9s.ui.skin = "skin";
    skins.skin = themeSource;

    aliases.aliases = {
      cr = "clusterrole";
      crb = "clusterrolebinding";
      de = "deployment";
      dp = "deployment";
      rb = "rolebinding";
      sec = "secrets";
    };
  };

}
