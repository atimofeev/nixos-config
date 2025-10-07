{
  vars,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.services.logrotate-nvim;
in
{

  options.custom.services.logrotate-nvim = {
    enable = lib.mkEnableOption "logrotate-nvim bundle";
  };

  config = lib.mkIf cfg.enable {
    services.logrotate = {
      enable = true;
      settings = {
        "/home/${vars.username}/.local/state/nvim/*log" = {
          size = "5M";
          rotate = 4;
          compress = true;
          missingok = true;
          notifempty = true;
          copytruncate = true;
        };
      };
    };
  };

}
