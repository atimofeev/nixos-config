{ lib, config, ... }:
let
  cfg = config.custom.services.auto-cpufreq;
in
{

  options.custom.services.auto-cpufreq = {
    enable = lib.mkEnableOption "auto-cpufreq bundle";
    battery_performance = lib.mkOption {
      default = "power";
      type = lib.types.str;
    };
    charger_performance = lib.mkOption {
      default = "performance";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.auto-cpufreq = {
      enable = true;
      settings = {

        battery = {
          governor = "powersave";
          energy_performance_preference = cfg.battery_performance;
          turbo = "never";
        };

        charger = {
          governor = "performance";
          energy_performance_preference = cfg.charger_performance;
          turbo = "auto";
        };

      };
    };
  };

}
