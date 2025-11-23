{ lib, config, ... }:
let
  cfg = config.custom.system.logind;
  suspend-command =
    if config.custom.hardware.power.hibernate then "suspend-then-hibernate" else "suspend";
in
{

  options.custom.system.logind = {
    enable = lib.mkEnableOption "logind bundle";
  };

  config = lib.mkIf cfg.enable {
    services.logind = {
      powerKey = suspend-command;
      powerKeyLongPress = "poweroff";
      lidSwitch = suspend-command;
      lidSwitchExternalPower = suspend-command;
      lidSwitchDocked = suspend-command;
    };
  };

}
