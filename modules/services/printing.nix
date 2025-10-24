{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.printing;
in
{

  options.custom.services.printing = {
    enable = lib.mkEnableOption "printing bundle";
  };

  config = lib.mkIf cfg.enable {
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };
  };

}
