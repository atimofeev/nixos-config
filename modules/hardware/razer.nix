{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.peripherals.razer;
in
{

  options.custom.hardware.peripherals.razer = {
    enable = lib.mkEnableOption "Razer bundle";
  };

  config = lib.mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      users = config.custom.hm-users;
      batteryNotifier.enable = false;
    };
  };

}
