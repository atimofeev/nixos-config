{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.system.boot;
in
{

  options.custom.system.boot = {
    enable = lib.mkEnableOption "boot bundle";
    kernelPackages = lib.mkOption {
      default = pkgs.linuxPackages;
      type = lib.types.raw;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      inherit (cfg) kernelPackages;
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 15;
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };

}
