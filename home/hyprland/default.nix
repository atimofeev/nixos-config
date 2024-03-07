{ pkgs, inputs, vars, ... }:
# TODO: apply colors:
# https://github.com/catppuccin/hyprland
# https://github.com/catppuccin/waybar
# https://github.com/catppuccin/rofi
# https://github.com/catppuccin/dunst
# https://github.com/catppuccin/sddm
# https://github.com/catppuccin/swaylock
# https://github.com/catppuccin/gtk
# https://github.com/catppuccin/cursors

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    # ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

    sleep 1

    ${pkgs.swww}/bin/swww img ${../../assets/wallpaper.jpg} &
  '';
in {

  imports =
    [ ./keybinds.nix ./window-rules.nix ./settings.nix ./waybar ./apps ];

  home.packages = with pkgs; [
    sddm # display manager
    dunst # notifications
    libnotify
    #hyprpaper # wallpaperd. others: swaybg, wpaperd, mpvpaper, swww
    swww
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = "${startupScript}/bin/start";

      "plugin:borders-plus-plus" = {
        add_borders = 1; # 0 - 9

        # you can add up to 9 borders
        "col.border_1" = "rgb(ffffff)";
        "col.border_2" = "rgb(2222ff)";

        # -1 means "default" as in the one defined in general:border_size
        border_size_1 = 10;
        border_size_2 = -1;

        # makes outer edges match rounding of the parent. Turn on / off to better understand. Default = on.
        natural_rounding = "yes";
      };
    };
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };
}
