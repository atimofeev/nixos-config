{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services.dbus;
in
{

  options.custom.services.dbus = {
    enable = lib.mkEnableOption "dbus bundle";

  };

  config = lib.mkIf cfg.enable {
    services.dbus = {
      enable = true;
      implementation = "broker";
    };
  };

}
