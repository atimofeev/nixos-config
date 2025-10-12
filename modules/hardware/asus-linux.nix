{ config, lib, ... }:
let
  cfg = config.custom.hardware.asus-linux;
in
{

  options.custom.hardware.asus-linux = {
    enable = lib.mkEnableOption "asus-linux bundle";
  };

  config = lib.mkIf cfg.enable {

    services = {
      supergfxd = {
        enable = true;
        settings = {
          mode = "Integrated";
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
        enableUserService = true;
        asusdConfig.text = # ron
          ''
            (
              charge_control_end_threshold: 80,
              // disable_nvidia_powerd_on_battery: true,
              // ac_command: "",
              // bat_command: "",
              //
              // platform_profile_linked_epp: true,
              // platform_profile_on_battery: Quiet,
              // platform_profile_on_ac: Performance,
              //
              // change_platform_profile_on_battery: true,
              // change_platform_profile_on_ac: true,
              //
              // profile_quiet_epp: Power,
              // profile_balanced_epp: BalancePower,
              // profile_custom_epp: Performance,
              // profile_performance_epp: Performance,
              //
              // ac_profile_tunings: {},
              // dc_profile_tunings: {},
              // armoury_settings: {},
            )
          '';
        profileConfig.text = # ron
          ''
            (
              active_profile: Quiet,
            )
          '';
        # fanCurvesConfig.text = # ron
        #   ''
        #     (
        #       profiles: (
        #         balanced: [
        #           (
        #             fan: CPU,
        #             pwm: (2, 22, 45, 68, 91, 153, 153, 153),
        #             temp: (55, 62, 66, 70, 74, 78, 78, 78),
        #             enabled: false,
        #           ),
        #           (
        #             fan: GPU,
        #             pwm: (2, 25, 48, 71, 94, 165, 165, 165),
        #             temp: (55, 62, 66, 70, 74, 78, 78, 78),
        #             enabled: false,
        #           ),
        #         ],
        #         performance: [
        #           (
        #             fan: CPU,
        #             pwm: (35, 68, 79, 91, 114, 175, 175, 175),
        #             temp: (58, 62, 66, 70, 74, 78, 78, 78),
        #             enabled: false,
        #           ),
        #           (
        #             fan: GPU,
        #             pwm: (35, 71, 84, 94, 119, 188, 188, 188),
        #             temp: (58, 62, 66, 70, 74, 78, 78, 78),
        #             enabled: false,
        #           ),
        #         ],
        #         quiet: [
        #           (
        #             fan: CPU,
        #             pwm: (2, 12, 22, 35, 45, 58, 79, 79),
        #             temp: (55, 62, 66, 70, 74, 78, 82, 82),
        #             enabled: true,
        #           ),
        #           (
        #             fan: GPU,
        #             pwm: (2, 12, 25, 35, 48, 61, 84, 84),
        #             temp: (55, 62, 66, 70, 74, 78, 82, 82),
        #             enabled: true,
        #           ),
        #         ],
        #         custom: [],
        #       ),
        #     )
        #   '';
      };
    };
  };
}
