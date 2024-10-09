{ config, vars, ... }: {

  sops.secrets."work/officeVPNcreds".restartUnits =
    [ "openvpn-officeVPN.service" ];

  services.openvpn.servers = {

    officeVPN = {
      updateResolvConf = true;
      config = ''
        config /home/${vars.username}/secrets/officeVPN.conf
        auth-user-pass ${config.sops.secrets."work/officeVPNcreds".path}
      '';
    };

    AH-VPN = {
      # https://ipmilist.advancedhosters.com/
      config = "config /home/${vars.username}/secrets/AH-VPN.conf";
    };

  };

}
