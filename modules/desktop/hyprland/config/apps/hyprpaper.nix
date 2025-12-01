{ lib, vars, ... }:
{

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ vars.wallpaper ];
      wallpaper = [ ",${vars.wallpaper}" ];
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

}
