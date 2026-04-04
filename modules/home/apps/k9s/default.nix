{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.k9s;
in
{

  imports = [ ./plugins ];

  options.custom-hm.applications.k9s = {
    enable = lib.mkEnableOption "k9s bundle";
    package = lib.mkPackageOption pkgs "k9s" { };
  };

  config = lib.mkIf cfg.enable {
    programs.k9s = {
      enable = true;
      inherit (cfg) package;

      aliases = {
        cr = "clusterrole";
        crb = "clusterrolebinding";
        de = "deployment";
        dp = "deployment";
        rb = "rolebinding";
        sec = "secrets";
      };
    };
  };

}
