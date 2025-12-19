{ lib, config, ... }:
let
  cfg = config.custom.services.power-profiles-daemon;
in
{

  options.custom.services.power-profiles-daemon = {
    enable = lib.mkEnableOption "power-profiles-daemon bundle";
  };

  config = lib.mkIf cfg.enable {
    services.power-profiles-daemon = {
      enable = true;
    };
  };

}
