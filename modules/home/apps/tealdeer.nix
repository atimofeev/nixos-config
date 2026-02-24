{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.tealdeer;
in
{

  options.custom-hm.applications.tealdeer = {
    enable = lib.mkEnableOption "tealdeer bundle";
    package = lib.mkPackageOption pkgs "tealdeer" { };
  };

  config = lib.mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      inherit (cfg) package;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates.auto_update = true;
      };
    };
  };

}
