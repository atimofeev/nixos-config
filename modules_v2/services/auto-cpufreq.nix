{ lib, config, ... }:
let
  cfg = config.custom.services.auto-cpufreq;
in
{

  options.custom.services.auto-cpufreq = {
    enable = lib.mkEnableOption "auto-cpufreq bundle";
    battery_performance = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
    charger_performance = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.auto-cpufreq = {
      enable = true;
      settings = {

        battery = {
          governor = "powersave";
          turbo = "never";
        }
        // lib.optionalAttrs (cfg.battery_performance != null) {
          energy_performance_preference = cfg.battery_performance;
        };

        charger = {
          governor = "performance";
          turbo = "auto";
        }
        // lib.optionalAttrs (cfg.charger_performance != null) {
          energy_performance_preference = cfg.charger_performance;
        };

      };
    };
  };

}
