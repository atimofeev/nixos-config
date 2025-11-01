{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [

    (inputs.nixos-hardware + "/common/cpu/intel")
    (inputs.nixos-hardware + "/common/gpu/intel/kaby-lake")

    ./hardware-configuration.nix
    ./sound.nix

    ../../modules/desktop/hyprland
    # ../../modules/desktop/gnome

  ];

  # Xiaomi Mi Notebook Pro 15.6 2018
  # CPU: i7-8550U (Kaby Lake)
  # iGPU: UHD Graphics 620
  # dGPU: Nvidia MX150 (Pascal)

  networking.hostName = "milaptop";
  time.timeZone = "Europe/Podgorica";
  system.stateVersion = "24.11";

  custom.hm-users = [
    "atimofeev"
    "alice"
  ];

  hardware = {
    intelgpu.driver = "i915";
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

      open = false;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x8086", ATTRS{device}=="0x5917", SYMLINK+="dri/igpu"
    SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x10de", ATTRS{device}=="0x1d12", SYMLINK+="dri/dgpu"
  '';

  custom = {

    hardware = {
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
      network = {
        enable = true;
        hotspot-bypass = true;
      };
    };

    services = {
      auto-cpufreq = {
        enable = true;
        settings = {
          battery.energy_performance_preference = "balance_power";
          charger = {
            energy_performance_preference = "performance";
            turbo = "true";
          };
        };
      };
      docker.enable = true;
      homepage.enable = true;
      kanata = {
        enable = true;
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      };
      logrotate-nvim.enable = true;
      printing.enable = true;
      syncthing.enable = true;
      yubikey = {
        enable = true;
        yubikey-touch-detector = true;
      };
    };

    work = {
      openvpn.enable = true;
      ansible = {
        enable = true;
        package = pkgs.ansible_2_17;
      };
      cato = {
        enable = true;
        package = pkgs.unstable.cato-client;
      };
      jira-cli = {
        enable = true;
        package = pkgs.unstable.jira-cli-go;
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
