{
  config,
  lib,
  ...
}:
let
  firefoxCfg = config.custom-hm.applications.firefox;
  cfg = firefoxCfg.userContent;
in
{

  options.custom-hm.applications.firefox.userContent = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = firefoxCfg.enable;
      description = "firefox userContent";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.firefox.profiles.default.userContent = # css
      ''
        /* dark background for default tabs */
        @-moz-document url("about:home"), url("about:blank"), url("about:newtab") {
          body {
            background-color: #24273a !important;
          }
        }
      '';

  };

}
