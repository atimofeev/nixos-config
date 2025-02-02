_: {

  powerManagement.enable = true;

  services = {
    power-profiles-daemon.enable = false; # to avoid collision with auto-cpufreq

    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 7;
      percentageAction = 3;
      criticalPowerAction = "Hibernate";
    };

    auto-cpufreq = {
      enable = true;
      settings = {

        battery = {
          governor = "powersave";
          turbo = "never";
          scaling_max_freq = 1500 * 1000;
        };

        charger = {
          governor = "performance";
          turbo = "auto";
          # scaling_max_freq = 2000000;
        };

      };
    };

  };

  # tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;
  #
  #     # Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #   };
  # };

}
