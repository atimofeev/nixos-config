{
  config,
  lib,
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

      settings = lib.mkMerge (
        map (u: {
          "/home/${u}/.local/state/nvim/*log" = {
            compress = true;
            copytruncate = true;
            missingok = true;
            notifempty = true;
            rotate = 4;
            size = "5M";
          };
        }) config.custom.hm-users
      );

    };
  };

}
