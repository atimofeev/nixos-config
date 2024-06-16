{ pkgs, ... }:
# steam game launch options: nvidia-offload %command%
{
  environment.systemPackages = with pkgs; [ nvtopPackages.full gwe glxinfo ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
