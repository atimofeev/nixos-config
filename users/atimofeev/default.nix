{ pkgs, ... }:
{

  imports = [

    ../../home/terminal
    ../../home/firefox

    ../../home/mpv.nix
    ../../home/obsidian.nix
    ../../home/qbittorrent.nix
    ../../home/zen-browser.nix

  ];

  custom-hm = {

    user = {
      launcher.app = "vicinae";
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

    applications = {
      rofi.enable = true;
      swappy.enable = true;
      vcv-rack.enable = true;
      zathura.enable = true;
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
      vicinae = {
        enable = true;
        package = pkgs.unstable.vicinae;
      };
    };

    system = {
      nix-index.enable = true;
    };

  };

}
