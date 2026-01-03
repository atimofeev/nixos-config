{ lib, config, ... }:
let
  cfg = config.custom.services.tlp;

  defaultSettings = {
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;

    CPU_HWP_DYN_BOOST_ON_AC = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    PCIE_ASPM_ON_AC = "default";
    # PCIE_ASPM_ON_BAT = "powersupersave"; # TODO: try out
    PCIE_ASPM_ON_BAT = "powersave";
  };
in
{

  options.custom.services.tlp = {
    enable = lib.mkEnableOption "tlp bundle";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = false;
      tlp = {
        enable = true;
        settings = lib.recursiveUpdate defaultSettings cfg.settings;
      };
    };
  };

}
