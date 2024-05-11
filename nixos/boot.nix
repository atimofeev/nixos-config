{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 15;
      efi.canTouchEfiVariables = true;
    };
  };
}
