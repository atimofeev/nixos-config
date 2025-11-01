{ config, lib, ... }:
let
  cfg = config.custom.hardware.asus-backlight-fix;
in
{

  options.custom.hardware.asus-backlight-fix = {
    enable = lib.mkEnableOption "Fix screen backlight control in Hybrid GPU mode";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "i915.enable_dpcd_backlight=1"
      "xe.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };

}
