{
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
    ../../modules/desktop/niri
    # ../../modules/desktop/gnome

  ];

  # Xiaomi Mi Notebook Pro 15.6 2018
  # CPU: i7-8550U (Kaby Lake)
  # iGPU: UHD Graphics 620
  # dGPU: Nvidia MX150 (Pascal)

  networking.hostName = "milaptop";
  time.timeZone = "Europe/Podgorica";
  system.stateVersion = "24.11";

  hardware = {
    intelgpu.driver = "i915";
    enableRedistributableFirmware = true;
    nvidia = {
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

    user-shell = "fish";

    hm-users = [
      "atimofeev"
      "alice"
    ];

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      peripherals = {
        zsa.enable = true;
      };
      power = {
        enable = true;
        hibernate = true;
      };
      sound.enable = true;
      ssd.enable = true;
    };

    system = {
      automount.enable = true;
      boot = {
        enable = true;
        kernelPackages = pkgs.linuxPackages_6_18;
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
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      };
      logrotate-nvim.enable = true;
      power-profiles-daemon.enable = true;
      printing.enable = true;
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
      openvpn.enable = true;
      wpa2-enterprise-fix.enable = true;
    };

  };

}
