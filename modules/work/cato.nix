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
    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to auto-start cato-client systemd service on boot";
    };
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

    systemd.services.cato-client = {
      wantedBy = lib.mkIf (!cfg.autoStart) (lib.mkForce [ ]);
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
        cato-restart = "sudo pkill -9 -f cato; sudo sed -i '/10.254.254.1/d' /etc/resolv.conf; sudo systemctl start cato-client";
        cato-start = "cato-sdp start";
        cato-status = "cato-sdp status";
        cato-stop = "cato-sdp stop";
      };

    };

  };

}
