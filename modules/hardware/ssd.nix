{ lib, config, ... }:
let
  cfg = config.custom.hardware.ssd;
in
{

  options.custom.hardware.ssd = {
    enable = lib.mkEnableOption "SSD bundle";
  };

  config = lib.mkIf cfg.enable {
    services.fstrim.enable = true;
  };

}
