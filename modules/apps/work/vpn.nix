{ config, vars, ... }:
let
  catoCAPem = builtins.fetchurl {
    url =
      "https://clientdownload.catonetworks.com/public/certificates/CatoNetworksTrustedRootCA.pem";
    sha256 = "19kgv6lvhs3i30sxj3f4x7z843jci5c902lp41ghsrsjmbsljzqx";
  };
in {

  sops.secrets = {
    "work/officeVPNcreds".restartUnits = [ "openvpn-officeVPN.service" ];
    "work/dnsmasq-config".restartUnits = [ "dnsmasq.service" ];
  };

  security.pki.certificateFiles = [ catoCAPem ];

  home-manager.users.${vars.username}.programs.firefox.policies = {

    Certificates = {
      ImportEnterpriseRoots = true;
      Install = [ catoCAPem ];
    };

    DNSOverHTTPS = {
      Enabled = false;
      Locked = true;
    };

  };

  services = {

    cato-client.enable = true;

    openvpn.servers = {

      officeVPN = {
        # updateResolvConf = true;
        autoStart = false;
        config = ''
          config /home/${vars.username}/secrets/officeVPN.conf
          auth-user-pass ${config.sops.secrets."work/officeVPNcreds".path}
        '';
      };

      AH-VPN = {
        autoStart = false;
        # https://ipmilist.advancedhosters.com/
        config = "config /home/${vars.username}/secrets/AH-VPN.conf";
      };

    };

    # dnsmasq = {
    #   enable = true;
    #   resolveLocalQueries = true;
    #   settings = {
    #     conf-file = [ "${config.sops.secrets."work/dnsmasq-config".path}" ];
    #   };
    # };

  };

}
