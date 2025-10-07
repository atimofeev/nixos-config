{ lib, config, ... }:
let
  cfg = config.custom.system.logind;
in
{

  options.custom.system.logind = {
    enable = lib.mkEnableOption "logind bundle";
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
