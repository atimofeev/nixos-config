{ inputs, pkgs, vars, ... }: {

  nixpkgs.overlays = [ inputs.hyprpanel.overlay ];

  services = {
    gvfs.enable = true;
    # power-profiles-daemon.enable = true;
    upower.enable = true;
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
