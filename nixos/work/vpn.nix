{ config, vars, ... }: {

  sops.secrets = {
    "work/officeVPNcreds".restartUnits = [ "openvpn-officeVPN.service" ];
    "work/dnsmasq-config".restartUnits = [ "dnsmasq.service" ];
  };

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

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      conf-file = [ "${config.sops.secrets."work/dnsmasq-config".path}" ];
    };
  };

}
