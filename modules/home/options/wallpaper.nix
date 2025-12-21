{ config, lib, ... }:
let
  cfg = config.custom-hm.user.wallpaper;
in
{

  options.custom-hm.user = {

    wallpaper = {
      source = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the wallpaper source (e.g., inputs.my-wallpaper)";
      };
      dest = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/Pictures/Wallpapers";
        description = "The absolute path to the wallpaper directory.";
      };
    };

  };

  config = lib.mkIf (cfg.source != null) {
    home.file."${cfg.dest}" = {
      inherit (cfg) source;
      recursive = false;
    };
  };

}
