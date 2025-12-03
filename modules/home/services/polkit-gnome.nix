{
  config,
  lib,
  ...
}:
let
  cfg = config.custom-hm.services.polkit-gnome;
in
{

  options.custom-hm.services.polkit-gnome = {
    enable = lib.mkEnableOption "polkit-gnome bundle";
  };

  config = lib.mkIf cfg.enable {

    services.polkit-gnome = {
      enable = true;
    };

  };

}
