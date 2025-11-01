{
  config,
  lib,
  ...
}:
{

  options.custom.work.openvpn.enable = lib.mkEnableOption "OpenVPN client bundle";

  config = lib.mkIf config.custom.work.openvpn.enable {

    sops.secrets = {
      "work/officeVPNcreds".restartUnits = [ "openvpn-officeVPN.service" ];
    };

    security = {
      sudo = {
        extraRules = [
          {
            groups = [ "wheel" ];
            runAs = "root";
            commands = [
              {
                command = "/run/current-system/sw/bin/systemctl restart openvpn-officeVPN.service";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/systemctl start openvpn-officeVPN.service";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/systemctl stop openvpn-officeVPN.service";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
    };

    services = {

      openvpn.servers = {

        officeVPN = {
          # updateResolvConf = true;
          autoStart = false;
          config = ''
            config /home/${config.custom.hm-admin}/secrets/officeVPN.conf
            auth-user-pass ${config.sops.secrets."work/officeVPNcreds".path}
          '';
        };

        AH-VPN = {
          autoStart = false;
          # https://ipmilist.advancedhosters.com/
          config = "config /home/${config.custom.hm-admin}/secrets/AH-VPN.conf";
        };

      };

    };

  };

}
