{ vars, ... }: {

  # NOTE: fixes service ordering
  # wait for https://github.com/nix-community/home-manager/pull/6423
  systemd.user.services.hyprpaper.Unit = {
    After = [ "graphical-session.target" ];
    PartOf = [ "graphical-session.target" ];
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [ vars.wallpaper ];
      wallpaper = [ ",${vars.wallpaper}" ];
    };
  };

}
