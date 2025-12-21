{
  config,
  lib,
  ...
}:
let
  cfg = config.custom-hm.services.hyprpaper;
  wall = config.custom-hm.user.wallpaper;
in
{

  options.custom-hm.services.hyprpaper = {
    enable = lib.mkEnableOption "hyprpaper bundle";
  };

  config = lib.mkIf cfg.enable {

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "${wall.dest}/dark-shore.png" ];
        wallpaper = [ ",${wall.dest}/dark-shore.png" ];
      };
    };

    systemd.user.services.hyprpaper = {
      Install = {
        WantedBy = lib.mkForce [ "wayland-wm@Hyprland.service" ];
      };
      Unit = {
        After = lib.mkForce [ "wayland-wm@Hyprland.service" ];
        PartOf = lib.mkForce [ "wayland-wm@Hyprland.service" ];
      };
    };

  };

}
