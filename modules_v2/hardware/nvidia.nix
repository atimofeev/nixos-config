{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.hardware.nvidia;
in
{

  options.custom.hardware.nvidia = {
    enable = lib.mkEnableOption "Nvidia bundle";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nvtopPackages.full ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      prime = {
        offload = {
          enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
        };
      };
    };
  };

}
