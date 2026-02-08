{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.greetd;
in
{

  options.custom.services.greetd = {
    enable = lib.mkEnableOption "greetd bundle";
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${lib.getExe pkgs.tuigreet}"
            "--asterisks"
            "--remember"
            "--remember-user-session"
            ''
              --greeting "Hey you. You're finally awake."

            ''
          ];
          user = "greeter";
        };
      };
    };
  };

}
