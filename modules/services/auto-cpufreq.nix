{ lib, config, ... }:
let
  cfg = config.custom.services.auto-cpufreq;

  defaultSettings = {
    battery = {
      governor = "powersave";
      turbo = "never";
      energy_performance_preference = "default";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
      energy_performance_preference = "default";
    };
  };
in
{

  options.custom.services.auto-cpufreq = {
    enable = lib.mkEnableOption "auto-cpufreq bundle";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.auto-cpufreq = {
      enable = true;
      settings = lib.recursiveUpdate defaultSettings cfg.settings;
    };
  };

}
