{ inputs, pkgs, ... }:
{

  imports = [

    ../../home/terminal

  ];

  custom-hm = {

    user = {
      terminal = "kitty";
      editor = "nix run ~/repos/nixvim-config/";
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
      wallpaper.source = inputs.walls;
    };

    applications = {
      atuin.enable = true;
      btop.enable = true;
      carapace.enable = true;
      eza.enable = true;
      firefox = {
        enable = true;
        betterfox = {
          enable = true;
          settings = {
            fastfox.enable = true;
          };
        };
      };
      git.enable = true;
      htop = {
        enable = true;
        package = pkgs.htop-vim;
      };
      mpv.enable = true;
      obsidian.enable = true;
      qbittorrent.enable = true;
      rofi.enable = true;
      spotify-player = {
        enable = true;
        package = pkgs.unstable.spotify-player;
      };
      starship.enable = true;
      swappy.enable = true;
      vcv-rack.enable = true;
      yazi.enable = true;
      zathura.enable = true;
      zen-browser.enable = true;
      zoxide.enable = true;
    };

    services = {
      cliphist.enable = true;
      dank-material-shell.enable = true;
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
