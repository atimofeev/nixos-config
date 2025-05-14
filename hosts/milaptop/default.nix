_: {

  imports = [

    ./hardware-configuration.nix
    ./sound.nix
    ./hacks.nix

    ../../modules/system

    ../../modules/hardware/bluetooth
    ../../modules/hardware/intel/kaby-lake.nix
    ../../modules/hardware/nvidia
    ../../modules/hardware/peripherals/razer.nix
    # ../../modules/hardware/peripherals/zsa.nix
    ../../modules/hardware/power
    ../../modules/hardware/sound
    ../../modules/hardware/ssd

    ../../modules/desktop/hyprland
    # ../../modules/desktop/gnome

    ../../modules/apps
    ../../modules/apps/games
    ../../modules/apps/utils
    ../../modules/apps/work

    # ../../modules/services/nbfc # FIX: breaks bluetooth for some reason
    ../../modules/services/auto-cpufreq
    # ../../modules/services/convertx
    ../../modules/services/docker
    ../../modules/services/homepage
    ../../modules/services/logrotate
    # ../../modules/services/ollama
    # ../../modules/services/stirling-pdf
    ../../modules/services/syncthing
    ../../modules/services/xremap

  ];

  # CPU: i7-8550U (Kaby Lake)
  # iGPU: UHD Graphics 620
  # GPU: Nvidia MX150 (Pascal)

  networking.hostName = "milaptop";

  hardware = {

    enableRedistributableFirmware = true;

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

  services.auto-cpufreq.settings.battery.energy_performance_preference =
    "balance_power";

}
