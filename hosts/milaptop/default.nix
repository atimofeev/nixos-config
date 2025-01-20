_: {

  imports = [

    ./hardware-configuration.nix
    ./sound.nix
    ./hacks.nix

    ../../modules/system

    ../../modules/hardware/bluetooth
    ../../modules/hardware/intel
    ../../modules/hardware/nvidia
    ../../modules/hardware/power
    ../../modules/hardware/razer
    ../../modules/hardware/sound
    ../../modules/hardware/ssd

    ../../modules/desktop/hyprland
    # ../../modules/desktop/gnome

    ../../modules/apps
    ../../modules/apps/games
    ../../modules/apps/utils
    ../../modules/apps/work

    ../../modules/services/docker
    ../../modules/services/homepage
    ../../modules/services/logrotate
    # ../../modules/services/nbfc # TODO: fix
    ../../modules/services/ollama
    ../../modules/services/syncthing
    ../../modules/services/xremap

  ];

  hardware = {

    # GPU: Nvidia MX150 (Pascal)
    nvidia = {
      open = false;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    bluetooth.settings.General.ControllerMode =
      "bredr"; # Fixes Marshall Motif II LE mode

  };

}
