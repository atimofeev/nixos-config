_: {

  # TODO: complete config

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
