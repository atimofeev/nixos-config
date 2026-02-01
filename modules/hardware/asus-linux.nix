{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.hardware.asus-linux;
in
{

  options.custom.hardware.asus-linux = {
    enable = lib.mkEnableOption "asus-linux bundle";
    package = lib.mkPackageOption pkgs "asusctl" { };
  };

  config = lib.mkIf cfg.enable {

    custom.services.power-profiles-daemon.enable = true;

    services = {

      supergfxd = {
        enable = true;
        settings = {
          mode = "Hybrid";
          vfio_enable = false;
          vfio_save = false;
          always_reboot = false;
          no_logind = false;
          logout_timeout_s = 180;
          hotplug_type = "None";
        };
      };

      asusd = {
        enable = true;
        inherit (cfg) package;
        enableUserService = true;
        auraConfigs."19b6".text = # ron
          ''
            (
                config_name: "aura_19b6.ron",
                brightness: Med,
                current_mode: Static,
                builtins: {
                    Static: (
                        mode: Static,
                        zone: r#None,
                        colour1: (
                            r: 0,
                            g: 198,
                            b: 255,
                        ),
                        colour2: (
                            r: 0,
                            g: 0,
                            b: 0,
                        ),
                        speed: Med,
                        direction: Right,
                    ),
                },
                multizone_on: false,
                enabled: (
                    states: [
                        (
                            zone: Keyboard,
                            boot: false,
                            awake: true,
                            sleep: false,
                            shutdown: false,
                        ),
                    ],
                ),
            )
          '';

        asusdConfig.text = # ron
          ''
            (
                charge_control_end_threshold: 80,
                disable_nvidia_powerd_on_battery: true,
                ac_command: "",
                bat_command: "",
                platform_profile_linked_epp: true,
                platform_profile_on_battery: Quiet,
                change_platform_profile_on_battery: true,
                platform_profile_on_ac: Balanced,
                change_platform_profile_on_ac: true,
                profile_quiet_epp: Power,
                profile_balanced_epp: BalancePerformance,
                profile_custom_epp: Performance,
                profile_performance_epp: Performance,
                ac_profile_tunings: {
                    Performance: (
                        enabled: false,
                        group: {},
                    ),
                },
                dc_profile_tunings: {
                    Quiet: (
                        enabled: false,
                        group: {},
                    ),
                    Balanced: (
                        enabled: false,
                        group: {},
                    ),
                    Performance: (
                        enabled: false,
                        group: {},
                    ),
                },
                armoury_settings: {},
            )
          '';

      };
    };
  };
}
