{ ... }: {
  powerManagement.enable = true;
  services = {
    power-profiles-daemon.enable = false; # to avoid collision with auto-cpufreq
    auto-cpufreq.enable = true;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        scaling_max_freq = 1000000;
      };
      charger = {
        governor = "performance";
        turbo = "auto";
        scaling_max_freq = 2000000;
      };
    };
  };
}
