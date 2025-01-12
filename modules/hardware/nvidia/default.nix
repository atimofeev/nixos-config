{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ nvtopPackages.full ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

}
