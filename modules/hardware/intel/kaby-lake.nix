{ pkgs, ... }: {

  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelParams =
      [ "i915.enable_guc=2" "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.intel-media-driver ];
  };

}
