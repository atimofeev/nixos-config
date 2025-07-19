{ pkgs, ... }:
{

  imports = [

    ./hardware-configuration.nix
    ./sound.nix
    ./hacks.nix

    ../../modules/system

    ../../modules/hardware/bluetooth
    ../../modules/hardware/intel/kaby-lake.nix
    ../../modules/hardware/nvidia
    # ../../modules/hardware/peripherals/logitech.nix
    # ../../modules/hardware/peripherals/razer.nix
    ../../modules/hardware/peripherals/zsa.nix
    ../../modules/hardware/power
    ../../modules/hardware/sound
    ../../modules/hardware/ssd

    ../../modules/desktop/hyprland
    # ../../modules/desktop/gnome

    ../../modules/apps
    ../../modules/apps/games
    ../../modules/apps/utils

  ];

  # CPU: i7-8550U (Kaby Lake)
  # iGPU: UHD Graphics 620
  # GPU: Nvidia MX150 (Pascal)

  networking.hostName = "milaptop";

  custom = {

    services = {
      auto-cpufreq = {
        enable = true;
        battery_performance = "balance_power";
      };
      docker.enable = true;
      homepage.enable = true;
      kanata = {
        enable = true;
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      };
      logrotate-nvim.enable = true;
      nbfc = {
        enable = false; # FIX: breaks bluetooth
        configName = "Xiaomi Mi Book (TM1613, TM1703)";
      };
      syncthing.enable = true;
      yubikey.enable = true;
    };

    work = {
      ansible = {
        enable = true;
        package = pkgs.ansible_2_17;
      };
      cato.enable = true;
      kube-tools.enable = true;
      opentofu = {
        enable = true;
        package = pkgs.unstable.opentofu;
      };
      openvpn.enable = true;
      misc-tools.enable = true;
      wpa2-enterprise-fix.enable = true;
    };

  };

  hardware = {

    enableRedistributableFirmware = true;

    nvidia = {
      open = false;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    bluetooth.settings.General.ControllerMode = "bredr"; # Fixes Marshall Motif II LE mode

  };

  # services.auto-cpufreq.settings.battery.energy_performance_preference = "balance_power";

}
