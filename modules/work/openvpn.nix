{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.openvpn;
  hmUser = config.custom.hm-admin;
in
{

  options.custom.work.openvpn = {
    enable = lib.mkEnableOption "OpenVPN client bundle";
    autoStart = lib.mkEnableOption "Autostart main VPN connection";
  };

  config = lib.mkIf cfg.enable {

    sops.secrets = {
      "work/openvpn-main-files/ca".owner = config.custom.hm-admin;
      "work/openvpn-main-files/cert".owner = config.custom.hm-admin;
      "work/openvpn-main-files/key".owner = config.custom.hm-admin;
      "work/openvpn-main-files/ta".owner = config.custom.hm-admin;
    };

    networking.networkmanager = {

      plugins = [ pkgs.networkmanager-openvpn ];

      ensureProfiles.profiles.openvpn-main = {
        connection = {
          id = "openvpn-main";
          type = "vpn";
          autoconnect = cfg.autoStart;
          permissions = "user:${hmUser}:";
        };
        vpn = {
          auth = "SHA512";
          ca = config.sops.secrets."work/openvpn-main-files/ca".path;
          cert = config.sops.secrets."work/openvpn-main-files/cert".path;
          cipher = "AES-256-CBC";
          data-ciphers = "AES-256-CBC:AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305";
          data-ciphers-fallback = "AES-256-CBC";
          comp-lzo = "adaptive";
          allow-compression = "asym";
          connection-type = "$OPENVPN_MAIN_CONNECTION_TYPE";
          dev = "tun";
          key = config.sops.secrets."work/openvpn-main-files/key".path;
          password-flags = "0";
          remote = "$OPENVPN_MAIN_REMOTE";
          remote-cert-tls = "server";
          service-type = "org.freedesktop.NetworkManager.openvpn";
          ta = config.sops.secrets."work/openvpn-main-files/ta".path;
          ta-dir = "1";
          tls-cipher = "$OPENVPN_MAIN_TLS_CIPHER";
          tunnel-mtu = "1400";
          username = "$OPENVPN_MAIN_USERNAME";
        };
        ipv4 = {
          method = "auto";
          never-default = true;
          ignore-auto-dns = true;
          dns-priority = 50;
        };
        ipv6 = {
          method = "disabled";
        };
        vpn-secrets.password = "$OPENVPN_MAIN_PASSWORD";
      };

    };

    home-manager.users.${hmUser}.custom-hm.user.shellAliases = {
      vpn-start = "nmcli connection up openvpn-main";
      vpn-stop = "nmcli connection down openvpn-main";
      vpn-restart = "nmcli connection down openvpn-main; nmcli connection up openvpn-main";
      vpn-status = "nmcli connection show openvpn-main";
    };

  };

}
