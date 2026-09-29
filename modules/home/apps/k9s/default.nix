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
      package = cfg.package.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./global-hotkeys.patch ];
      });
      aliases = {
        cr = "clusterrole";
        crb = "clusterrolebinding";
        de = "deployment";
        dp = "deployment";
        rb = "rolebinding";
        sec = "secrets";
      };
      hotKeys = {
        back = {
          description = "Back";
          global = "back";
          override = true;
          shortCut = "q";
        };
        backspace = {
          description = "Back";
          global = "back";
          override = true;
          shortCut = "Backspace";
        };
        command-mode = {
          description = "Command mode";
          global = "command";
          override = true;
          shortCut = ";";
        };
      };
    };
  };

}
