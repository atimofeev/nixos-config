{
  config,
  lib,
  ...
}:
let
  cfg = config.custom-hm.system.qt;
in
{

  options.custom-hm.system.qt = {
    enable = lib.mkEnableOption "Qt bundle";
  };

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };
  };

}
