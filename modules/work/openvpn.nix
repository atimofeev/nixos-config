{
  config,
  lib,
  ...
}:
{

  options.custom.work.openvpn.enable = lib.mkEnableOption "OpenVPN client bundle";

  config = lib.mkIf config.custom.work.openvpn.enable {

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

      # NOTE: defined in ../system/secrets.nix
      # officeVPN = {
      #   # updateResolvConf = true;
      #   autoStart = false;
      # };

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
