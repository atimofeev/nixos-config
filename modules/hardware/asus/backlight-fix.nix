{ config, lib, ... }:
let
  cfg = config.custom.hardware.asus.backlight-fix;
in
{

  options.custom.hardware.asus.backlight-fix = {
    enable = lib.mkEnableOption "Fix screen backlight control in Hybrid GPU mode";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "i915.enable_psr=0" # NOTE: reduce flickering at low brightness
      "xe.enable_psr=0"
      "i915.enable_dpcd_backlight=3" # NOTE: fix backlight control
      "xe.enable_dpcd_backlight=3"
    ];
  };

}
