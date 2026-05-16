{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.asus.stuck-active-dgpu-fix;

in
{

  options.custom.hardware.asus.stuck-active-dgpu-fix = {
    enable = lib.mkEnableOption "Helps getting Nvidia card to sleep after being active";
  };

  config = lib.mkIf cfg.enable {

    boot.kernelParams = lib.mkAfter [
      "nvidia-drm.fbdev=0"
    ];

  };

}
