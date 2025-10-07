{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.sunshine;
in
{

  options.custom.services.sunshine = {
    enable = lib.mkEnableOption "sunshine bundle";
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      package = pkgs.sunshine.override { cudaSupport = true; };
      openFirewall = true;
      capSysAdmin = true;
    };
  };

}
