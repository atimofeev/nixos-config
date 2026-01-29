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
      type = lib.types.str;
      readOnly = true;
      description = "The command string for the currently active launcher.";
    };
  };

  config = {
    custom-hm.user.launcher.command =
      let
        launcherMap = {
          rofi = config.custom-hm.applications.rofi.command;
          vicinae = config.custom-hm.services.vicinae.command;
          dms = config.custom-hm.services.dank-material-shell.launcher-cmd;
        };
      in
      launcherMap.${cfg.app};
  };

}
