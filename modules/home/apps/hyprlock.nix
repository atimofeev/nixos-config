{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.hyprlock;
  date = lib.getExe' pkgs.coreutils "date";
  wall = config.custom-hm.user.wallpaper;
in
{

  options.custom-hm.applications.hyprlock = {
    enable = lib.mkEnableOption "hyprlock bundle";
    package = lib.mkPackageOption pkgs "hyprlock" { };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      inherit (cfg) package;

      settings = {
        background = [
          {
            blur_passes = 3;
            blur_size = 8;
            brightness = 0.7172;
            contrast = 0.8916;
            path = wall.dest + "/dark-shore.png";
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];

        general.hide_cursor = true;

        input-field = [
          {
            dots_center = true;
            dots_size = 0.4;
            dots_spacing = 0.2;
            fade_on_empty = false;
            font_color = "rgb(255,255,255)";
            halign = "center";
            hide_input = false;
            inner_color = "rgba(255, 255, 255, 0.1)";
            monitor = "eDP-1";
            outer_color = "rgba(255, 255, 255, 0)";
            outline_thickness = 2;
            placeholder_text = "<i>...</i>";
            position = "0, -50";
            size = "300, 60";
            valign = "center";
          }
        ];

        label = [
          {
            font_size = 28;
            halign = "center";
            monitor = "eDP-1";
            position = "0, -50";
            text = ''cmd[update:10000] echo -e "$(${date} +"%A, %B %d")"'';
            valign = "top";
          }
          {
            font_family = "steelfish outline regular";
            font_size = 80;
            halign = "center";
            monitor = "eDP-1";
            position = "0, -125";
            text = ''cmd[update:10000] echo "<span>$(${date} +"%H:%M")</span>"'';
            valign = "top";
          }
          {
            font_size = 18;
            halign = "center";
            monitor = "eDP-1";
            position = "0, 0";
            text = "    $USER";
            valign = "center";
          }
        ];
      };
    };
  };

}
