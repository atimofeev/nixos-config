{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.imv;
in
{

  options.custom-hm.applications.imv = {
    enable = lib.mkEnableOption "imv bundle";
    package = lib.mkPackageOption pkgs "imv" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."imv/config".text = ''
      [options]
      recursive = true
    '';
  };

}
