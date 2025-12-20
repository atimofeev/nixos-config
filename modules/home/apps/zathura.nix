{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.zathura;
in
{

  options.custom-hm.applications.zathura = {
    enable = lib.mkEnableOption "zathura bundle";
    package = lib.mkPackageOption pkgs "zathura" { };
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      inherit (cfg) package;
      options = {
        guioptions = "none";
        adjust-open = "best-fit";
        selection-clipboard = "clipboard";
      };
      mappings = {
        ";" = "focus_inputbar ':'";
        b = "adjust_window best-fit";
        w = "adjust_window width";
        t = "recolor";
      };
    };
  };

}
