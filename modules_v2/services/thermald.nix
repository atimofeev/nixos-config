{ lib, config, ... }:
let
  cfg = config.custom.services.thermald;
in
{

  options.custom.services.thermald = {
    enable = lib.mkEnableOption "thermald bundle";
  };

  config = lib.mkIf cfg.enable {
    services.thermald = {
      enable = true;
    };
  };

}
