{ libx, pkgs, ... }:
# TODO: remap ; -> :
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
    # FIX: custom lib source
    # https://github.com/luisnquin/nixos-config/blob/628f3f1e4598f59f871c02c85aeb1d09bba84201/lib/formats.nix
    # skin = libx.formats.fromYAML themeSource;
  };
}
