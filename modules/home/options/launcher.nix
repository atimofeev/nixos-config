{
  config,
  lib,
  ...
}:

let
  cfg = config.custom-hm.user.launcher;
in
{

  options.custom-hm.user.launcher = {
    app = lib.mkOption {
      type = lib.types.enum [
        "rofi"
        "vicinae"
        "dms"
      ];
      default = "rofi";
      description = "Which app launcher to use.";
    };
    command = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      readOnly = true;
      description = "Launcher default CMD";
    };
    clipboard-cmd = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      readOnly = true;
      description = "Launcher CMD for clipboard manager";
    };
    web-search-cmd = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      readOnly = true;
      description = "Launcher CMD for web search";
    };
  };

  config =
    let
      launcherMap = {
        rofi = config.custom-hm.applications.rofi;
        vicinae = config.custom-hm.services.vicinae;
        dms = config.custom-hm.services.dank-material-shell;
      };
    in
    {
      custom-hm.user.launcher = {
        inherit (launcherMap.${cfg.app}) command clipboard-cmd web-search-cmd;
      };
    };

}
