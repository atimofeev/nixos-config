{ lib, config, ... }:
let
  cfg = config.custom.system.locale;
in
{

  options.custom.system.locale = {
    enable = lib.mkEnableOption "locale bundle";
    defaultLocale = lib.mkOption {
      default = null;
      type = lib.types.str;
    };
    extraLocale = lib.mkOption {
      default = null;
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    i18n = {
      inherit (cfg) defaultLocale;

      extraLocaleSettings = {
        LC_ADDRESS = cfg.extraLocale;
        LC_IDENTIFICATION = cfg.extraLocale;
        LC_MEASUREMENT = cfg.extraLocale;
        LC_MONETARY = cfg.extraLocale;
        LC_NAME = cfg.extraLocale;
        LC_NUMERIC = cfg.extraLocale;
        LC_PAPER = cfg.extraLocale;
        LC_TELEPHONE = cfg.extraLocale;
        LC_TIME = cfg.extraLocale;
      };
    };
  };

}
