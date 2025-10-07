{ lib, config, ... }:
let
  cfg = config.custom.system.automount;
in
{

  options.custom.system.automount = {
    enable = lib.mkEnableOption "automount bundle";
  };

  config = lib.mkIf cfg.enable {
    services = {
      devmon.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
    };
  };

}
