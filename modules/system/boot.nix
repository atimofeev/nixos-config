{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 15;
      };
      efi.canTouchEfiVariables = true;
    };
  };

}
