# FIX: breaks bluetooth if enabled
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.nbfc;
in
{

  options.custom.services.nbfc = {
    enable = lib.mkEnableOption "nbfc bundle";
    configName = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nbfc-linux ];
    systemd.services.nbfc = {
      enable = true;
      description = "NoteBook FanControl service";
      path = [ pkgs.kmod ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          conf = pkgs.writeText "nbfc.json" (
            builtins.toJSON {
              SelectedConfigId = "${cfg.configName}";
              EmbeddedControllerType = "ec_sys_linux";
            }
          );
        in
        {
          Type = "simple";
          Restart = "always";
          RestartSec = "3";
          ExecStart = "${pkgs.nbfc-linux}/bin/nbfc_service -c ${conf}";
          TimeoutStopSec = "5";
        };
    };
  };

}
