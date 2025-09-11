{ pkgs, ... }:
{

  imports = [

    # ./hardware-configuration.nix

    ../../modules/desktop/hyprland

  ];

  # CPU: Intel Core Ultra 9 285H (Arrow Lake)
  # iGPU: Intel Arc 140T
  # GPU: Nvidia RTX 5070 Ti (Blackwell)

  networking.hostName = "zefir";
  time.timeZone = "Europe/Podgorica";

  services.asusd.enable = true;

  # These flags are used to enable backlight control when the dGPU is working in hybrid mode
  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.settings.General.ControllerMode = "bredr"; # Fixes Marshall Motif II LE mode
    nvidia = {
      open = true;
      modesetting.enable = true;
      dynamicBoost.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
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
      # intel.kaby-lake.enable = true;
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
      lanzaboote.enable = true;
      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "en_GB.UTF-8";
      };
      logind.enable = true;
      network.enable = true;
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
        # devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      };
      logrotate-nvim.enable = true;
      syncthing.enable = true;
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
      cato = {
        enable = true;
        package = pkgs.unstable.cato-client;
      };
      kube-tools.enable = true;
      opentofu = {
        enable = true;
        package = pkgs.unstable.opentofu;
      };
      misc-tools.enable = true;
      wpa2-enterprise-fix.enable = true;
    };

  };

}
