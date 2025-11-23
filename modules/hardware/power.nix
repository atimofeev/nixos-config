{ lib, config, ... }:
let
  cfg = config.custom.hardware.power;
in
{

  options.custom.hardware.power = {
    enable = lib.mkEnableOption "Power bundle";
    hibernate = lib.mkOption {
      description = "Enable hibernation";
      default = false;
      type = lib.types.bool;
    };

  };

  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    services = {
      power-profiles-daemon.enable = lib.mkIf config.services.auto-cpufreq.enable false;
      upower = lib.mkMerge [
        {
          enable = true;
          percentageLow = 15;
          percentageCritical = 10;
        }
        # NOTE: may be already handled via systemd
        (lib.mkIf cfg.hibernate {
          percentageAction = 5;
          criticalPowerAction = "Hibernate";
        })
      ];
    };
    systemd.sleep.extraConfig = # ini
      ''
        HibernateOnACPower=false
      '';
  };

}
