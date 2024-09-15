{ pkgs, ... }:
# example config:
# https://github.com/RicArch97/nixos-config/blob/main/modules/desktop/apps/zathura.nix
let
  themeName = "catppuccin-macchiato";
  themeSource = pkgs.fetchFromGitHub
    {
      owner = "catppuccin";
      repo = "zathura";
      rev = "1bda9d8274dd327b7931886ef0c5c1eb33903814";
      sha256 = "sha256-HWOc5tnVgU/HUcVcIXACeuu3RDH1pHO/8DQRsWqumIA=";
    } + "/src/${themeName}"; # path to theme in repo
in
{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
      adjust-open = "best-fit";
      selection-clipboard = "clipboard";
    };
    mappings = {
      ";" = "focus_inputbar ':'";
      b = "adjust_window best-fit";
    };
    extraConfig = "include ${themeSource}";
  };
}
