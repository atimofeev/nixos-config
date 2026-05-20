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

      ensureProfiles = {

        profiles."GlobalProtect" = {
          connection = {
            id = "GlobalProtect";
            type = "vpn";
            autoconnect = false;
            permissions = "user:${hmUser}:";
          };
          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            protocol = "gp";
            gateway = "$GP_PORTAL";
            enable-csd-trojan = "yes";
            csd_wrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
          };
          ipv4 = {
            method = "auto";
          };
        };
      };

    };

  };
}
