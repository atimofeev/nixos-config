{ pkgs, ... }: {

  # CPU: i7-8550U (Kaby Lake)
  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };
  };

  # iGPU drivers
  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" ];
  };

}
