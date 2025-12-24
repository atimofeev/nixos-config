{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom-hm.applications.firefox.betterfox;
in
{

  imports = [ inputs.betterfox.homeModules.betterfox ];

  options.custom-hm.applications.firefox.betterfox = {
    enable = lib.mkEnableOption "betterfox bundle";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox.betterfox = {
      enable = true;
      profiles.default = {
        inherit (cfg) settings;
      };
    };
  };

}
