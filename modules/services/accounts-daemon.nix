{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services.accounts-daemon;
in
{

  options.custom.services.accounts-daemon = {
    enable = lib.mkEnableOption "accounts-daemon bundle";

  };

  config = lib.mkIf cfg.enable {
    services.accounts-daemon.enable = true;
  };

}
