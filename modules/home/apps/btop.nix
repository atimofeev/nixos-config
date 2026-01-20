{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.btop;
  inherit (osConfig.custom.hardware) amdgpu nvidia;
in
{

  options.custom-hm.applications.btop = {
    enable = lib.mkEnableOption "btop bundle";
    package = lib.mkPackageOption pkgs "btop" {
      default =
        if nvidia.enable then
          "btop-cuda"
        else if amdgpu.enable then
          "btop-rocm"
        else
          "btop";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      inherit (cfg) package;
      settings = {
        vim_keys = true;
        update_ms = 500;
        proc_gradient = false;
        proc_per_core = true;
      };
    };
  };

}
