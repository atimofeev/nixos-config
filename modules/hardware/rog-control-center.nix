{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hardware.rog-control-center;
  pkg = config.custom.hardware.asus-linux.package;
in
{

  options.custom.hardware.rog-control-center = {
    enable = lib.mkEnableOption "rog-control-center bundle";
    package = lib.mkOption {
      default = pkg;
      type = lib.types.package;
    };
    target = lib.mkOption {
      default = "graphical-session.target";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    # NOTE: https://github.com/NixOS/nixpkgs/issues/455932
    # programs.rog-control-center = {
    #   enable = true;
    #   autoStart = true;
    # };

    systemd.user.services.rog-control-center = {
      description = "rog-control-center";
      after = [ cfg.target ];
      partOf = [ cfg.target ];
      startLimitBurst = 5;
      startLimitIntervalSec = 120;
      wantedBy = [ cfg.target ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe' cfg.package "rog-control-center";
        Restart = "always";
        RestartSec = 1;
        TimeoutStopSec = 10;
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      };
    };

  };

}
