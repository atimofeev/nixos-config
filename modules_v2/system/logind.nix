{ lib, config, ... }:
let
  cfg = config.custom.system.logind;
in
{

  options.custom.system.logind = {
    enable = lib.mkEnableOption "logind bundle";
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
    services.logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "suspend";
      lidSwitchDocked = "suspend";
    };
  };

}
