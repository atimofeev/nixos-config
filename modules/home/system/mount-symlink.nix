{
  config,
  lib,
  osConfig ? {},
  ...
}:
let
  cfg = config.custom-hm.system.mount-symlink;
  osCfg = osConfig.custom.system.automount or {};
in
{

  options.custom-hm.system.mount-symlink = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osCfg.enable or false;
      description = "Enable symlink to media mounts";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file."Mount" = {
      source = config.lib.file.mkOutOfStoreSymlink "/run/media/${config.home.username}";
      recursive = false;
    };
  };

}
