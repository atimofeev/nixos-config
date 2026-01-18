{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.firefox;
in
{

  options.custom-hm.applications.firefox = {
    enable = lib.mkEnableOption "firefox bundle";
    package = lib.mkPackageOption pkgs "firefox" { };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      inherit (cfg) package;
      profiles.default.isDefault = true;
    };
  };

}
