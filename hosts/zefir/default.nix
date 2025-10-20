{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [

    inputs.nixos-hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix
    ./sound-fix.nix

    ../../modules/desktop/hyprland

  ];

  # Asus Zephyrus G16 2025 GU605CR
  # CPU: Intel Core Ultra 9 285H
  # iGPU: Intel Arc 140T
  # dGPU: Nvidia RTX 5070 Ti (Blackwell)

  networking.hostName = "zefir";
  time.timeZone = "Europe/Podgorica";

  hardware = {
    intelgpu.driver = "xe";
    enableRedistributableFirmware = true;
    nvidia = {

      # NOTE: linux 6.17 compat override
      # https://github.com/NixOS/nixpkgs/issues/429624
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "580.95.05";
        sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
        sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
        openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
        settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
        persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
      };

      open = true;
      modesetting.enable = true;
      dynamicBoost.enable = true;
      # powerManagement = {
      #   enable = true;
      #   finegrained = true;
      # };
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
  environment.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/igpu:/dev/dri/dgpu";

  custom = {

    hardware = {
      asus-linux.enable = true;
      asus-fn-lock-fix.enable = true;
      bluetooth.enable = true;
      nvidia.enable = true;
      peripherals = {
        motiff-ii-fix.enable = true;
        zsa.enable = true;
      };
      power.enable = true;
      sound.enable = true;
      ssd.enable = true;
    };

    system = {
      automount.enable = true;
      boot = {
        enable = true;
        kernelPackages = pkgs.linuxPackages_6_17;
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
        # settings.battery.energy_performance_preference = "balance_power";
      };
      docker.enable = true;
      homepage.enable = true;
      kanata = {
        enable = true;
        devices = [ "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:6:1.0-event-mouse" ];
      };
      logrotate-nvim.enable = true;
      # syncthing.enable = true;
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
