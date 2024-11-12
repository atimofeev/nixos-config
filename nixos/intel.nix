{ pkgs, lib, ... }: {
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

  # Backward-compat for 24.05, can be removed after upgrade to 24.11
  imports = lib.optionals (lib.versionOlder lib.version "24.11pre") [
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable" ] [
      "hardware"
      "opengl"
      "enable"
    ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages" ] [
      "hardware"
      "opengl"
      "extraPackages"
    ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages32" ] [
      "hardware"
      "opengl"
      "extraPackages32"
    ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable32Bit" ] [
      "hardware"
      "opengl"
      "driSupport32Bit"
    ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package" ] [
      "hardware"
      "opengl"
      "package"
    ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package32" ] [
      "hardware"
      "opengl"
      "package32"
    ])
  ];

}
