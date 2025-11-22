{ lib, config, ... }:
let
  cfg = config.custom.hardware.power;
in
{

  options.custom.hardware.power = {
    enable = lib.mkEnableOption "Power bundle";
  };

  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    services = {
      power-profiles-daemon.enable = lib.mkIf config.services.auto-cpufreq.enable false;
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 10;
        percentageAction = 5;
        criticalPowerAction = "Hibernate";
      };
    };
    systemd.sleep.extraConfig = # ini
      ''
        HibernateOnACPower=false
      '';
  };

}
