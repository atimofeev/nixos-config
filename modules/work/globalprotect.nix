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

    environment.systemPackages = with pkgs; [
      gnome-keyring
      gp-saml-gui
      openconnect
    ];

    services.gnome.gnome-keyring = {
      enable = true;
    };

    networking.networkmanager = {

      plugins = [
        pkgs.networkmanager-openconnect
      ];

      ensureProfiles.profiles = {

        "GlobalProtect-AH" = {
          connection = {
            id = "GlobalProtect-AH";
            type = "vpn";
            autoconnect = false;
            permissions = "user:${hmUser}:";
          };
          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            protocol = "gp";
            gateway = "$GLOBALPROTECT_GATEWAY_AH";
            csd_wrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
            enable_csd_trojan = "yes";
            usergroup = "gateway";
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
            service-type = "org.freedesktop.NetworkManager.openconnect";
            protocol = "gp";
            gateway = "$GLOBALPROTECT_GATEWAY_HTZ";
            csd_wrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
            enable_csd_trojan = "yes";
            usergroup = "gateway";
          };
          ipv4 = {
            method = "auto";
          };
        };
      };

    };

  };
}
