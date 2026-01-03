{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.power-profiles-daemon;
in
{

  options.custom.services.power-profiles-daemon = {
    enable = lib.mkEnableOption "power-profiles-daemon bundle";
    package = lib.mkPackageOption pkgs "power-profiles-daemon" { };
  };

  config = lib.mkIf cfg.enable {
    services = {

      auto-cpufreq.enable = false;
      tlp.enable = false;

      power-profiles-daemon = {
        enable = true;
        inherit (cfg) package;
      };

    };
  };

}
