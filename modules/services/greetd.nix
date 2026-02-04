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

    # NOTE: prevent systemd messages appearing on top of greetd
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

  };

}
