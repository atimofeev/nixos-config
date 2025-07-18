{
  config,
  lib,
  pkgs,
  # buildFHSUserEnv,
  # libnl,
  # openssl,
  # zlib,
  ...
}:

# with lib;

let
  cfg = config.custom.work.crowdstrike-falcon;

  falcon-env = pkgs.buildFHSUserEnv {
    name = "falcon-env";
    targetPkgs = pkgs: [
      pkgs.libnl
      pkgs.openssl
      pkgs.zlib
    ];

    extraInstallCommands = ''
      ln -s ${pkgs.falcon}/* $out/
    '';

    runScript = "bash";
  };

  startPreScript = pkgs.writeScript "init-falcon" ''
    #! ${pkgs.bash}/bin/sh
    ${falcon-env}/bin/falcon-env
    mkdir -p /opt/CrowdStrike
    ln -sf ${pkgs.falcon}/opt/CrowdStrike/* /opt/CrowdStrike
    ${pkgs.falcon}/opt/CrowdStrike/falconctl -s -f --cid='${cfg.cid}'
    # ${pkgs.falcon}/opt/CrowdStrike/falconctl -s -f --tags='${cfg.email}'
    # ${pkgs.falcon}/opt/CrowdStrike/falconctl -g --cid
  '';

in
{
  options.custom.work.crowdstrike-falcon = {
    enable = lib.mkEnableOption "Crowdstrike falcon sensor";
    email = lib.mkOption {
      type = lib.types.str;
      example = "john.doe@example.com";
      description = ''
        The email of the user.
      '';
    };
    cid = lib.mkOption {
      type = lib.types.str;
      description = ''
        The Crowdstrike customer ID.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.falcon-sensor = {
      enable = true;
      description = "CrowdStrike Falcon Sensor";
      unitConfig.DefaultDependencies = false;
      after = [ "local-fs.target" ];
      conflicts = [ "shutdown.target" ];
      before = [
        "sysinit.target"
        "shutdown.target"
      ];
      serviceConfig = {
        ExecStartPre = "${startPreScript}";
        ExecStart = "${falcon-env}/bin/falcon-env -c \"${falcon-env}/opt/CrowdStrike/falcond\"";
        Type = "forking";
        PIDFile = "/run/falcond.pid";
        Restart = "no";
        TimeoutStopSec = "60s";
        KillMode = "process";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
