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

    # NOTE: https://github.com/NixOS/nixpkgs/issues/455932
    # programs.rog-control-center = {
    #   enable = true;
    #   autoStart = true;
    # };

    systemd.user.services.rog-control-center =
      let
        target = "graphical-session.target";
      in
      {
        description = "rog-control-center";
        after = [ target ];
        partOf = [ target ];
        startLimitBurst = 5;
        startLimitIntervalSec = 120;
        wantedBy = [ target ];

        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe' cfg.package "rog-control-center";
          Restart = "always";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

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

        # fanCurvesConfig.text = # ron
        #   ''
        #     (
        #         profiles: (
        #             balanced: [
        #                 (
        #                     fan: CPU,
        #                     pwm: (2, 15, 25, 43, 61, 84, 107, 130),
        #                     temp: (0, 58, 62, 66, 70, 74, 78, 82),
        #                     enabled: false,
        #                 ),
        #                 (
        #                     fan: GPU,
        #                     pwm: (2, 7, 20, 30, 48, 66, 84, 107),
        #                     temp: (0, 52, 56, 60, 64, 68, 71, 74),
        #                     enabled: false,
        #                 ),
        #             ],
        #             performance: [
        #                 (
        #                     fan: CPU,
        #                     pwm: (25, 43, 61, 84, 107, 140, 178, 255),
        #                     temp: (0, 57, 61, 65, 69, 73, 78, 83),
        #                     enabled: true,
        #                 ),
        #                 (
        #                     fan: GPU,
        #                     pwm: (20, 30, 48, 66, 84, 122, 158, 181),
        #                     temp: (0, 47, 52, 57, 62, 67, 72, 77),
        #                     enabled: false,
        #                 ),
        #             ],
        #             quiet: [
        #                 (
        #                     fan: CPU,
        #                     pwm: (2, 15, 25, 43, 61, 89, 89, 89),
        #                     temp: (58, 62, 66, 70, 75, 80, 255, 255),
        #                     enabled: false,
        #                 ),
        #                 (
        #                     fan: GPU,
        #                     pwm: (2, 7, 20, 30, 48, 71, 71, 71),
        #                     temp: (49, 53, 57, 61, 65, 69, 255, 255),
        #                     enabled: false,
        #                 ),
        #             ],
        #             custom: [],
        #         ),
        #     )
        #   '';

      };
    };
  };
}
