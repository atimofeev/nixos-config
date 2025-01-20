_: {

  # TODO: complete config
  # https://fzakaria.com/2024/08/13/nixos-raspberry-pi-me.html

  imports = [

    ./hardware-configuration.nix

    ../../modules/system

    ../../modules/hardware/bluetooth
    ../../modules/hardware/sound
    ../../modules/hardware/ssd

    # ../../modules/desktop/hyprland
    ../../modules/desktop/gnome

    ../../modules/apps
    ../../modules/apps/utils

    ../../modules/services/docker
    ../../modules/services/logrotate
    ../../modules/services/pihole
    ../../modules/services/xremap

  ];

}
