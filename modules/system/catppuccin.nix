{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom.system.catppuccin;
in
{

  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  options.custom.system.catppuccin = {
    enable = lib.mkEnableOption "catppuccin bundle";
    accent = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
    flavor = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      accent = lib.mkIf (cfg.accent != null) cfg.accent;
      flavor = lib.mkIf (cfg.flavor != null) cfg.flavor;
    };
  };

}
