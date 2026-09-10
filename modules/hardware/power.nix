{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hardware.power;
  hasUsbAutosuspendExclusions = cfg.usb-autosuspend-exclusions != [ ];
  restoreUsbAutosuspendExclusions = pkgs.writeShellScript "restore-usb-autosuspend-exclusions" ''
    for device in /sys/bus/usb/devices/*; do
      [ -r "$device/idVendor" ] || continue
      [ -r "$device/idProduct" ] || continue
      [ -w "$device/power/control" ] || continue

      read -r vendorId < "$device/idVendor"
      read -r productId < "$device/idProduct"

      case "$vendorId:$productId" in
        ${
          lib.concatMapStringsSep "|" (
            device: "${device.vendorId}:${device.productId}"
          ) cfg.usb-autosuspend-exclusions
        })
          printf '%s\n' on > "$device/power/control"
          ;;
      esac
    done
  '';
  usbAutosuspendExclusionRules = lib.concatMapStringsSep "\n" (device: ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="${device.vendorId}", ATTR{idProduct}=="${device.productId}", TEST=="power/control", ATTR{power/control}="on"
  '') cfg.usb-autosuspend-exclusions;
in
{

  options.custom.hardware.power = {
    enable = lib.mkEnableOption "Power bundle";
    hibernate = lib.mkOption {
      description = "Enable hibernation";
      default = false;
      type = lib.types.bool;
    };
    powertop = lib.mkOption {
      description = "Enable powertop auto-tuning on resume";
      default = true;
      type = lib.types.bool;
    };
    usb-autosuspend-exclusions = lib.mkOption {
      description = "USB devices kept out of runtime autosuspend";
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            productId = lib.mkOption {
              description = "Four-digit USB product ID";
              type = lib.types.strMatching "[0-9a-fA-F]{4}";
            };
            vendorId = lib.mkOption {
              description = "Four-digit USB vendor ID";
              type = lib.types.strMatching "[0-9a-fA-F]{4}";
            };
          };
        }
      );
    };
    wifi-powersave = lib.mkOption {
      description = "Enable WiFi power saving via NetworkManager";
      default = true;
      type = lib.types.bool;
    };
    disable-wol = lib.mkOption {
      description = "Disable Wake-on-LAN on ethernet interfaces";
      default = false;
      type = lib.types.bool;
    };

  };

  config = lib.mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = cfg.powertop;
      resumeCommands = lib.concatStringsSep "\n" (
        lib.optional cfg.powertop "${pkgs.powertop}/bin/powertop --auto-tune"
        ++ lib.optional hasUsbAutosuspendExclusions "${restoreUsbAutosuspendExclusions}"
      );
    };
    networking.networkmanager.wifi.powersave = cfg.wifi-powersave;
    services = {
      upower = lib.mkMerge [
        {
          enable = true;
          percentageLow = 15;
          percentageCritical = 10;
        }
        # NOTE: may be already handled via systemd
        (lib.mkIf cfg.hibernate {
          percentageAction = 5;
          criticalPowerAction = "Hibernate";
        })
      ];
      udev.extraRules = lib.concatStringsSep "\n" (
        lib.optional cfg.disable-wol ''
          # Disable Wake-on-LAN on ethernet interfaces
          ACTION=="add", SUBSYSTEM=="net", KERNEL=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol d"
        ''
        ++ lib.optional hasUsbAutosuspendExclusions usbAutosuspendExclusionRules
      );
    };
    systemd.services.powertop.serviceConfig.ExecStartPost = lib.mkIf (
      cfg.powertop && hasUsbAutosuspendExclusions
    ) restoreUsbAutosuspendExclusions;
    systemd.sleep.settings.Sleep = {
      HibernateOnACPower = false;
    };
  };

}
