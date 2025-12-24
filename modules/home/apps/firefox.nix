{
  config,
  lib,
  ...
}:
let
  cfg = config.custom-hm.applications.firefox;
in
{

  options.custom-hm.applications.firefox = {
    enable = lib.mkEnableOption "firefox bundle";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default.isDefault = true;
    };
  };

}
