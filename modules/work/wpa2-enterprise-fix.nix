{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.wpa2-enterprise-fix;
in
{

  options.custom.work.wpa2-enterprise-fix = {
    enable = lib.mkEnableOption "WPA2-Enterprise PEAP fix";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.wpa_supplicant.environment.OPENSSL_CONF =
      pkgs.writeText "openssl.cnf" # conf
        ''
          openssl_conf = openssl_init
          [openssl_init]
          ssl_conf = ssl_sect
          [ssl_sect]
          system_default = system_default_sect
          [system_default_sect]
          Options = UnsafeLegacyRenegotiation
          [system_default_sect]
          CipherString = Default:@SECLEVEL=0
        '';
  };

}
