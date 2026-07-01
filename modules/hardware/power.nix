{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hardware.power;
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
      resumeCommands = lib.mkIf cfg.powertop "${pkgs.powertop}/bin/powertop --auto-tune";
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
      udev.extraRules = lib.mkIf cfg.disable-wol ''
        # Disable Wake-on-LAN on ethernet interfaces
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol d"
      '';
    };
    systemd.sleep.settings.Sleep = {
      HibernateOnACPower = false;
    };
  };

}
