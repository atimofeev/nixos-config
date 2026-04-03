{ config, lib, ... }:
let
  cfg = config.custom.hardware.asus.cpu-throttling-fix;
in
{

  options.custom.hardware.asus.cpu-throttling-fix = {
    enable = lib.mkEnableOption "Apply cpupower service to limit performance cores freq";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ config.boot.kernelPackages.cpupower ];

    systemd.services.cpupower-freq-limit = {
      description = "Cap maximum P-core frequency to prevent thermal overshoot";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${config.boot.kernelPackages.cpupower}/bin/cpupower -c 0-5 frequency-set -u 4.0GHz";
        RemainAfterExit = true;
      };
    };

  };

}
