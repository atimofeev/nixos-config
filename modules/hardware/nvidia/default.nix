{
  pkgs,
  lib,
  config,
  ...
}:
{

  environment.systemPackages = with pkgs; [ nvtopPackages.full ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
      };
    };
  };

}
