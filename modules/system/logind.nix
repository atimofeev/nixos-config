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
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "suspend-then-hibernate";
      lidSwitchDocked = "suspend-then-hibernate";
    };
  };

}
