{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.system.sops;
in
{

  # config = lib.mkIf cfg.enable {

  environment.shellInit = ''
    set -a
    source ${config.sops.secrets."work/env-vars".path}
    set +a
  '';

  services = {
    homepage-dashboard.environmentFile = config.sops.secrets."work/homepage-env".path;
    openvpn.servers.officeVPN.config = ''
      config /home/${config.custom.hm-admin}/secrets/officeVPN.conf
      auth-user-pass ${config.sops.secrets."work/vpn-creds".path}
    '';
  };

  sops.secrets = {
    "work/env-vars".owner = config.custom.hm-admin;
    "work/homepage-env" = {
      owner = config.custom.hm-admin;
      restartUnits = [ "homepage-dashboard.service" ];
    };
    "work/vpn-creds".restartUnits = [ "openvpn-officeVPN.service" ];
  };

  # };

}
