{ pkgs, ... }:
# FIX: breaks bluetooth if enabled
let

  nbfc = pkgs.nbfc-linux;

  configName = "Xiaomi Mi Book (TM1613, TM1703)";

  cfg = pkgs.writeText "nbfc.json" (
    builtins.toJSON {
      SelectedConfigId = "${configName}";
      EmbeddedControllerType = "ec_sys_linux";
    }
  );

in
{

  environment.systemPackages = [ nbfc ];
  systemd.services.nbfc = {
    enable = true;
    description = "NoteBook FanControl service";
    path = [ pkgs.kmod ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "3";
      ExecStart = "${nbfc}/bin/nbfc_service -c ${cfg}";
      TimeoutStopSec = "5";
    };
  };

}
