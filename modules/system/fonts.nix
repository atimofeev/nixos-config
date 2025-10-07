# TODO: add configurable main font (and pass it through to other apps)
# TODO: configure conditional font for Hyprpanel
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.system.fonts;
in
{

  options.custom.system.fonts = {
    enable = lib.mkEnableOption "fonts bundle";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      pkgs.nerd-fonts.dejavu-sans-mono
      pkgs.nerd-fonts.jetbrains-mono # Hyprpanel
    ];
  };

}
