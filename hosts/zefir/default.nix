{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [

    inputs.nixos-hardware.nixosModules.common-cpu-intel

    # ./disko-config.nix
    ./hardware-configuration.nix

    ../../modules/desktop/hyprland
    ../../modules/desktop/niri

  ];

  # Asus Zephyrus G16 2025 GU605CR
  # CPU: Intel Core Ultra 9 285H (Arrow Lake-H)
  # iGPU: Intel Arc 140T
  # dGPU: Nvidia RTX 5070 Ti (Blackwell)

  networking.hostName = "zefir";
  time.timeZone = "Europe/Podgorica";
  system.stateVersion = "24.11";

  boot = {
    blacklistedKernelModules = [
      # NOTE: block Realtek Card Reader, which prevents deep sleep
      "rtsx_pci"
      "rtsx_pci_sdmmc"
    ];
    kernelParams = [
      "pcie_aspm=force"
      "nvidia.NVreg_EnableS0ixPowerManagement=1"
    ];
  };

  hardware = {
    intelgpu.driver = "xe";
    enableRedistributableFirmware = true;
    nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
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

  # NOTE: proper GPU ordering
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x8086", ATTRS{device}=="0x7d51", SYMLINK+="dri/igpu"
    SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x10de", ATTRS{device}=="0x2f58", SYMLINK+="dri/dgpu"
  '';

  custom = {

    user-shell = "fish";

    hm-users = [
      "atimofeev"
      "alice"
    ];

    hardware = {
      asus-backlight-fix.enable = true;
      asus-linux = {
        enable = true;
        package = pkgs.unstable.asusctl;
      };
      asus-fn-lock-fix.enable = true;
      bluetooth.enable = true;
      nvidia.enable = true;
      peripherals = {
        logitech.logi-bolt-disable-wakeup = true;
        zsa.enable = true;
      };
      power.enable = true;
      rog-control-center = {
        enable = true;
        target = "dms.service";
      };
      sound.enable = true;
      ssd.enable = true;
    };

    system = {
      automount.enable = true;
      boot = {
        enable = true;
        kernelPackages = pkgs.linux-g14;
      };
      catppuccin = {
        enable = true;
        accent = "lavender";
        flavor = "mocha";
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
      sops.enable = true;
    };

    applications = {
      chromium.enable = true;
      common-gui.enable = true;
      common-terminal.enable = true;
      games.enable = true;
    };

    services = {
      accounts-daemon.enable = true;
      dbus.enable = true;
      docker.enable = true;
      greetd.enable = true;
      homepage = {
        enable = true;
        background_image = inputs.walls + "/dark-shore.png";
      };
      kanata = {
        enable = true;
        devices = [ "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:6:1.0-event-mouse" ];
      };
      logrotate-nvim.enable = true;
      netbootxyz.enable = true;
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
      kube-tools.enable = true;
      misc-tools.enable = true;
      opentofu = {
        enable = true;
        package = pkgs.unstable.opentofu;
      };
      wpa2-enterprise-fix.enable = true;
    };

  };

}
