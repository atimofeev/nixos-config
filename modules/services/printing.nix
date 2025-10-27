{
  config,
  lib,
  pkgs,
  vars,
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
    users.users.${vars.username}.extraGroups = [ "lp" ];
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        drivers = with pkgs; [
          cups-browsed
          cups-filters
          gutenprint
          hplip
          ipp-usb
        ];
      };
    };
  };

}
