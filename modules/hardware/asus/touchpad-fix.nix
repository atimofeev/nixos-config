{ config, lib, ... }:
let
  cfg = config.custom.hardware.asus.touchpad-fix;
in
{
  options.custom.hardware.asus.touchpad-fix = {
    enable = lib.mkEnableOption "Fix erratic Zephyrus touchpad (keep LPSS I2C awake)";
  };

  config = lib.mkIf cfg.enable {
    # Zephyrus G16 (GU605CR): the touchpad (ASUF1209) sits on the LPSS I2C
    # controller 0000:00:15.3 (0x8086:0x777b). Runtime PM suspends the
    # controller while idle; on wake it drops/batches event frames, making
    # tiny touchpad movements erratic and slow. Force it (and the sibling
    # controller 0x7778) to stay awake.
    services.udev.extraRules = ''
      SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x777b", ATTR{power/control}="on"
      SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x7778", ATTR{power/control}="on"
    '';
  };
}
