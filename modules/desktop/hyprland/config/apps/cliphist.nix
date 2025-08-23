{ lib, pkgs, ... }:
{

  wayland.windowManager.hyprland.settings.bind =
    let
      cliphist = lib.getExe pkgs.cliphist;
      rofi = lib.getExe pkgs.rofi-wayland;
      wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
      wtype = lib.getExe pkgs.wtype;
    in
    [
      "SUPER, V, exec, ${cliphist} list | ${rofi} -dmenu -p '󰍜 ' | ${cliphist} decode | ${wl-copy} && ${wtype} -M ctrl -P v -m ctrl -p v"
    ];

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ "graphical-session.target" ];
  };

}
