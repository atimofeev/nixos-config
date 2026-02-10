{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.work.openvpn;
in
{

  options.custom.work.openvpn = {
    enable = lib.mkEnableOption "OpenVPN client bundle";
    autoStart = lib.mkEnableOption "Autostart main VPN connection";
  };

  config = lib.mkIf cfg.enable {

    security.sudo.extraRules = [
      {
        groups = [ "wheel" ];
        runAs = "root";
        commands =
          map
            (action: {
              command = "/run/current-system/sw/bin/systemctl ${action} openvpn-officeVPN.service";
              options = [ "NOPASSWD" ];
            })
            [
              "restart"
              "start"
              "stop"
            ];
      }
    ];

    services.openvpn.servers = {

      # NOTE: config defined in ../system/secrets.nix
      officeVPN = {
        # updateResolvConf = true;
        inherit (cfg) autoStart;
      };

      AH-VPN = {
        autoStart = false;
        # https://ipmilist.advancedhosters.com/
        config = "config /home/${config.custom.hm-admin}/secrets/AH-VPN.conf";
      };

    };

    home-manager.users.${config.custom.hm-admin}.custom-hm.user.shellAliases = {
      vpn-restart = "sudo systemctl restart openvpn-officeVPN.service";
      vpn-start = "sudo systemctl start openvpn-officeVPN.service";
      vpn-status = "systemctl status openvpn-officeVPN.service";
      vpn-stop = "sudo systemctl stop openvpn-officeVPN.service";
    };

  };

}
