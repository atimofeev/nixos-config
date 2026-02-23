{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.gpu-ordering;
in
{

  options.custom.hardware.gpu-ordering = {
    enable = lib.mkEnableOption "GPU ordering bundle";
    dgpu = lib.mkOption {
      description = "vendor:device for dGPU";
      type = lib.types.str;
      example = "0x8086:0x7d51";
    };
    igpu = lib.mkOption {
      description = "vendor:device for iGPU";
      type = lib.types.str;
      example = "0x10de:0x2f58";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.sessionVariables = lib.mkIf config.programs.hyprland.enable {
      AQ_DRM_DEVICES = "/dev/dri/igpu:/dev/dri/dgpu";
    };

    services.udev.extraRules =
      let
        d = lib.splitString ":" cfg.dgpu;
        i = lib.splitString ":" cfg.igpu;
      in
      ''
        SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="${builtins.elemAt d 0}", ATTRS{device}=="${builtins.elemAt d 1}", SYMLINK+="dri/dgpu"
        SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="${builtins.elemAt i 0}", ATTRS{device}=="${builtins.elemAt i 1}", SYMLINK+="dri/igpu"
      '';

  };
}
