{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.system.network;
in
{

  options.custom.system.network = {
    enable = lib.mkEnableOption "network bundle";
    hotspot-bypass = lib.mkEnableOption "Bypass hotspot restrictions for certain ISPs";
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = lib.mkIf cfg.hotspot-bypass {
      "net.ipv4.ip_default_ttl" = 65;
      "net.ipv6.conf.all.hop_limit" = 65;
      "net.ipv6.conf.default.hop_limit" = 65;
      "net.ipv6.conf.*.hop_limit" = 65;
    };

    users.users = lib.attrsets.genAttrs config.custom.hm-users (_u: {
      extraGroups = [ "networkmanager" ];
    });

    networking = {

      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        plugins = [ pkgs.networkmanager-openvpn ];
        unmanaged = [ "docker*" ];
      };

      firewall = {
        logRefusedConnections = false;
      };

    };

    services.resolved.enable = true;
  };

}
