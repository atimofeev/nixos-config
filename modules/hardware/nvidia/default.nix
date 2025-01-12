{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ nvtopPackages.full ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # intelBusId = "PCI:0:2:0";
      # nvidiaBusId = "PCI:1:0:0";
    };
  };

}
