{ ... }: {
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 25;
    efi.canTouchEfiVariables = true;
  };
}
