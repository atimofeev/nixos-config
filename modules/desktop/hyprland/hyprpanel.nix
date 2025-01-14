{ inputs, pkgs, lib, vars, ... }: {

  nixpkgs.overlays = [ inputs.hyprpanel.overlay ];

  # Dependencies
  services = {
    gvfs.enable = lib.mkDefault true;
    power-profiles-daemon.enable = lib.mkDefault true;
    upower.enable = lib.mkDefault true;
  };

  home-manager.users.${vars.username} = {
    wayland.windowManager.hyprland.settings = {

      bind = let
        # prefix = "uwsm app --";
        prefix = "";
        pkill = "${pkgs.procps}/bin/pkill";
        hyprpanel = "${pkgs.hyprpanel}/bin/hyprpanel";
      in [ "SUPER, B, exec, ${pkill} hyprpanel || ${prefix} ${hyprpanel}" ];

      exec-once = [ "${pkgs.hyprpanel}/bin/hyprpanel" ];

    };

  };

}
