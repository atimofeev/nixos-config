{ pkgs, libx, ... }:
# TODO: remap ; -> :
# remap ESC (exit current view, or go back) -> Backspace / q
let
  themeName = "catppuccin-macchiato.yaml";
  themeSource = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "590a762110ad4b6ceff274265f2fe174c576ce96";
    sha256 = "sha256-EBDciL3F6xVFXvND+5duT+OiVDWKkFMWbOOSruQ0lus=";
  } + "/dist/${themeName}"; # path to theme in repo
in {

  programs.k9s = {
    enable = true;
    skin = libx.formats.fromYAML themeSource;
  };
}
