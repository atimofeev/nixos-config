{ lib, pkgs, ... }: {

  wayland.windowManager.hyprland.settings.bind = let
    cliphist = "${pkgs.cliphist}/bin/cliphist";
    rofi = lib.getExe pkgs.rofi-wayland;
    wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
    wtype = "${pkgs.wtype}/bin/wtype";
  in [
    "SUPER, V, exec, ${cliphist} list | ${rofi} -dmenu | ${cliphist} decode | ${wl-copy} && ${wtype} -M ctrl -P v -m ctrl -p v"
  ];

  # NOTE: remove during upgrade to 25.05
  # https://github.com/nix-community/home-manager/pull/6751
  systemd.user.services.cliphist.Unit.After =
    lib.mkForce "graphical-session.target";
  systemd.user.services.cliphist-images.Unit.After =
    lib.mkForce "graphical-session.target";

  services.cliphist = {
    enable = true;
    allowImages = true;
    # NOTE: switch during upgrade to 25.05
    # systemdTargets = [ "graphical-session.target" ];
    systemdTarget = "graphical-session.target";
  };

}
