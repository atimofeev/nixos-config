{ ... }: {
  powerManagement.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
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
}
