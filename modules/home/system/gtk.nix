{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.system.gtk;
in
{

  options.custom-hm.system.gtk = {
    enable = lib.mkEnableOption "GTK bundle";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      colorScheme = "dark";
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    home = {
      packages = with pkgs; [ adwaita-icon-theme-legacy ];
      sessionVariables.ADW_DISABLE_PORTAL = "1";
    };
  };

}
