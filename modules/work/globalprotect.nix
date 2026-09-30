{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.globalprotect;
  hmUser = config.custom.hm-admin;
in
{
  options.custom.work.globalprotect = {
    enable = lib.mkEnableOption "GlobalProtect VPN (NM + DMS)";
  };

  config = lib.mkIf cfg.enable {

    services.gnome.gnome-keyring.enable = true;

    networking.networkmanager = {

      plugins = [ pkgs.networkmanager-gpclient ];

      ensureProfiles.profiles = {

        "GlobalProtect-AMS" = {
          connection = {
            id = "GlobalProtect-AMS";
            type = "vpn";
            autoconnect = false;
            permissions = "user:${hmUser}:";
          };
          vpn = {
            as_gateway = "yes";
            browser = "embedded";
            cookie-flags = "2";
            csd_wrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
            enable_csd_trojan = "yes";
            gateway = "$GLOBALPROTECT_GATEWAY_AMS";
            gateway-flags = "2";
            service-type = "org.freedesktop.NetworkManager.gpclient";
          };
          ipv4 = {
            method = "auto";
          };
        };

        "GlobalProtect-HTZ" = {
          connection = {
            id = "GlobalProtect-HTZ";
            type = "vpn";
            autoconnect = false;
            permissions = "user:${hmUser}:";
          };
          vpn = {
            as_gateway = "yes";
            browser = "embedded";
            cookie-flags = "2";
            csd_wrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
            enable_csd_trojan = "yes";
            gateway = "$GLOBALPROTECT_GATEWAY_HTZ";
            gateway-flags = "2";
            service-type = "org.freedesktop.NetworkManager.gpclient";
          };
          ipv4 = {
            method = "auto";
          };
        };
      };

    };

  };
}
