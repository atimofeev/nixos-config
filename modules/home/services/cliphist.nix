{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.cliphist;

  cliphist = lib.getExe pkgs.cliphist;
  rofi = lib.getExe pkgs.rofi;
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  wtype = lib.getExe pkgs.wtype;
in
{

  options.custom-hm.services.cliphist = {
    enable = lib.mkEnableOption "cliphist bundle";
    command = lib.mkOption {
      default = "${cliphist} list | ${rofi} -dmenu -p '󰍜 ' | ${cliphist} decode | ${wl-copy} && ${wtype} -M ctrl -P v -m ctrl -p v";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    services.cliphist = {
      enable = true;
      allowImages = true;
      systemdTargets = [ "graphical-session.target" ];
    };

  };

}
