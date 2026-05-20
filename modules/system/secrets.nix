{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.system.sops;
in
{

  config = lib.mkIf cfg.enable {

    environment.shellInit = ''
      if [ -r ${config.sops.secrets."personal/env-vars".path} ]; then
        set -a
        source ${config.sops.secrets."personal/env-vars".path}
        set +a
      fi
      if [ -r ${config.sops.secrets."work/env-vars".path} ]; then
        set -a
        source ${config.sops.secrets."work/env-vars".path}
        set +a
      fi
    '';

    services.homepage-dashboard.environmentFile = config.sops.secrets."work/homepage-env".path;

    networking.networkmanager.ensureProfiles.environmentFiles = [
      config.sops.secrets."work/vpn-envs".path
    ];

    sops.secrets = {
      "personal/env-vars".owner = config.custom.hm-admin;
      "work/env-vars".owner = config.custom.hm-admin;
      "work/homepage-env" = {
        owner = config.custom.hm-admin;
        restartUnits = [ "homepage-dashboard.service" ];
      };
      "work/vpn-envs".owner = config.custom.hm-admin;
    };

  };

}
