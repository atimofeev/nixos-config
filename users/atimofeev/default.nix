{

  imports = [

    ../../home/terminal
    ../../home/firefox

    ../../home/mpv.nix
    ../../home/obsidian.nix
    ../../home/qbittorrent.nix
    ../../home/swappy.nix
    ../../home/vcv-rack.nix
    ../../home/zathura.nix
    ../../home/zen-browser.nix

  ];

  custom-hm = {

    user = {
      input = {
        repeat-delay = 275;
        repeat-rate = 35;
        mouse-sensitivity = -0.8;
        touchpad-sensitivity = -0.15;
        xkb = {
          layout = "us,ru";
          options = "grp:win_space_toggle";
        };
      };
    };

    services = {
      cliphist.enable = true;
      dankmaterialshell.enable = true;
      hypridle.enable = false;
      hyprpanel.enable = false;
      hyprpaper.enable = false;
      hyprsunset.enable = false;
      polkit-gnome.enable = true;
      syncthing.enable = true;
      vicinae.enable = true;
    };

    system = {
      nix-index.enable = true;
    };

  };

}
