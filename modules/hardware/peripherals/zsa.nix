{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ wally-cli ];
  users.groups.plugdev = { };
  antob.user.extraGroups = [ "plugdev" ];

  services.udev.extraRules = ''
    # Rules for Oryx web flashing and live training
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
    # Keymapp Flashing rules for the Voyager
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

  # NOTE: OR USE THIS INSTEAD

  hardware.keyboard.zsa.enable = true;
  # environment.systemPackages = with pkgs; [ wally-cli ];

}
