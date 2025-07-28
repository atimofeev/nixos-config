{ pkgs, ... }:
{

  imports = [

    ./hardware-configuration.nix
    ./sound.nix
    ./hacks.nix

    ../../modules/desktop/hyprland
    # ../../modules/desktop/gnome

  ];

  # CPU: i7-8550U (Kaby Lake)
  # iGPU: UHD Graphics 620
  # GPU: Nvidia MX150 (Pascal)

  networking.hostName = "milaptop";
  time.timeZone = "Europe/Podgorica";

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.settings.General.ControllerMode = "bredr"; # Fixes Marshall Motif II LE mode
    nvidia = {
      open = false;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  custom = {

    hardware = {
      bluetooth.enable = true;
      intel.kaby-lake.enable = true;
      nvidia.enable = true;
      peripherals.zsa.enable = true;
      power.enable = true;
      sound.enable = true;
      ssd.enable = true;
    };

    system = {
      automount.enable = true;
      boot = {
        enable = true;
        kernelPackages = pkgs.linuxPackages_latest;
      };
      fonts.enable = true;
      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "en_GB.UTF-8";
      };
      logind.enable = true;
      network = {
        enable = true;
        hotspot-bypass = true;
      };
    };

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
      thermald.enable = true;
      yubikey = {
        enable = true;
        yubikey-touch-detector = true;
      };
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

}
