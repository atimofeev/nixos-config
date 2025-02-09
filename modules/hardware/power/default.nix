{ lib, config, ... }: {

  powerManagement.enable = true;

  services = {

    power-profiles-daemon.enable =
      lib.mkIf config.services.auto-cpufreq.enable false;

    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 7;
      percentageAction = 3;
      criticalPowerAction = "Hibernate";
    };

  };

}
