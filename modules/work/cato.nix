{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.custom.work.cato;

  catoCAPem = builtins.fetchurl {
    url = "https://clientdownload.catonetworks.com/public/certificates/CatoNetworksTrustedRootCA.pem";
    sha256 = "19kgv6lvhs3i30sxj3f4x7z843jci5c902lp41ghsrsjmbsljzqx";
  };
in
{

  options.custom.work.cato = {
    enable = lib.mkEnableOption "Cato client bundle";
    package = lib.mkPackageOption pkgs "cato-client" { };
  };

  config = lib.mkIf cfg.enable {

    security = {

      pki.certificateFiles = [ catoCAPem ];

      sudo = {
        extraRules = [
          {
            groups = [ "wheel" ];
            runAs = "root";
            commands =
              map
                (action: {
                  command = "/run/current-system/sw/bin/systemctl ${action} cato-client.service";
                  options = [ "NOPASSWD" ];
                })
                [
                  "start"
                  "stop"
                  "restart"
                ];
          }
        ];
      };

    };

    services.cato-client = {
      enable = true;
      inherit (cfg) package;
    };

    home-manager.users.${config.custom.hm-admin}.programs.firefox.policies = {
      Certificates = {
        ImportEnterpriseRoots = true;
        Install = [ catoCAPem ];
      };
      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };
    };

  };

}
