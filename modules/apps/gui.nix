{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.applications.common-gui;
in
{

  options.custom.applications.common-gui = {
    enable = lib.mkEnableOption "common-gui bundle";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      # GUI/TUI apps
      emacs
      vscode
      firefox
      telegram-desktop
      spotify

      # typing
      keypunch
      gtypist

      # misc
      prusa-slicer
      freecad
      openscad
      upscayl
      eyedropper # pick colors
      parabolic # download video & audio
      # alpaca # chat with local LLMs
      unstable.winboat
    ];

  };

}
