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

      sudo.extraRules = [
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
                "kill"
                "restart"
                "start"
                "stop"
              ];
        }
      ];

    };

    services.cato-client = {
      enable = true;
      inherit (cfg) package;
    };

    # NOTE: not sure if this has any effect
    systemd.services.cato-client.serviceConfig = {
      ExecStart = lib.mkForce "${cfg.package}/bin/cato-clientd systemd --use-systemd-resolv";
    };

    home-manager.users.${config.custom.hm-admin} = {

      programs.firefox.policies = {
        Certificates = {
          ImportEnterpriseRoots = true;
          Install = [ catoCAPem ];
        };
        DNSOverHTTPS = {
          Enabled = false;
          Locked = true;
        };
      };

      custom-hm.user.shellAliases = {
        cato-restart = "sudo systemctl kill cato-client.service && sudo sed -i '/10.254.254.1/d' /etc/resolv.conf";
        cato-start = "cato-sdp start";
        cato-status = "cato-sdp status";
        cato-stop = "cato-sdp stop";
      };

    };

  };

}
