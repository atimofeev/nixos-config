{
  lib,
  osConfig,
  pkgs,
  vars,
  ...
}:
let

  uwsm = lib.getExe pkgs.uwsm;
  prefix = if osConfig.programs.hyprland.withUWSM then "${uwsm} app --" else "";
  pkill = lib.getExe' pkgs.procps "pkill";
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  wtype = lib.getExe pkgs.wtype;

in
{

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${vars.terminal.name} -e";

    plugins = with pkgs; [
      rofi-calc
      rofi-emoji-wayland
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

  wayland.windowManager.hyprland.settings.bind = [
    ''
      SUPER, A, exec, ${pkill} rofi || rofi -show drun -no-history -calc-command "echo -n '{result}' | ${wl-copy} && ${wtype} -M ctrl -P v -m ctrl -p v"
    ''
  ];

}
