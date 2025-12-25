{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let

  cfg = config.custom-hm.applications.rofi;
  launcher = config.custom-hm.user.launcher.app;

  uwsm = lib.getExe pkgs.uwsm;
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";
  pkill = lib.getExe' pkgs.procps "pkill";
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  wtype = lib.getExe pkgs.wtype;

in
{

  options.custom-hm.applications.rofi = {
    enable = lib.mkEnableOption "rofi bundle";
    package = lib.mkPackageOption pkgs "rofi" { };
    command = lib.mkOption {
      default = ''
        ${pkill} rofi || rofi -show drun -no-history -calc-command "echo -n '{result}' | ${wl-copy} && ${wtype} -M ctrl -P v -m ctrl -p v"
      '';
      type = lib.types.str;
    };
  };

  config = lib.mkIf (launcher == "rofi" || cfg.enable) {
    programs.rofi = {
      enable = true;
      inherit (cfg) package;
      terminal = "${config.custom-hm.user.terminal} -e";

      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];

      extraConfig = {
        modi = "drun,run,calc,ssh,emoji";
        display-drun = "󰘔 ";
        display-calc = "󱖦 ";
        display-ssh = " ";
        display-emoji = "󰞅 ";
        display-run = "󰲌 ";
        hover-select = true;
        show-icons = true;
        run-command = "${prefix} {cmd}";
      };

    };

  };

}
