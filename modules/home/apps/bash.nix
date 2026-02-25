{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.bash;
in
{

  options.custom-hm.applications.bash = {
    enable = lib.mkEnableOption "bash bundle";
    package = lib.mkPackageOption pkgs "bash" { };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      inherit (cfg) package;
      enableCompletion = true;
    };
  };

}
