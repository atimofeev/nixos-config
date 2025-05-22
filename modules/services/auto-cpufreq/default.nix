{ lib, ... }:
{

  services.auto-cpufreq = {
    enable = true;
    settings = {

      battery = {
        governor = "powersave";
        energy_performance_preference = lib.mkDefault "power";
        turbo = "never";
      };

      charger = {
        governor = "performance";
        energy_performance_preference = lib.mkDefault "performance";
        turbo = "auto";
      };

    };
  };

}
