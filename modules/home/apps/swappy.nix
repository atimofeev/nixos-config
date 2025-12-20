{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.swappy;
in
{

  options.custom-hm.applications.swappy = {
    enable = lib.mkEnableOption "swappy bundle";
    package = lib.mkPackageOption pkgs "swappy" { };
  };

  config = lib.mkIf cfg.enable {
    programs.swappy = {
      enable = true;
      inherit (cfg) package;
      settings.Default = {
        early_exit = true;
        save_dir = "$HOME/Downloads";
      };
    };
  };

}
