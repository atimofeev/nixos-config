{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.dcal;
in
{

  imports = [ inputs.dankcalendar.homeModules.dank-calendar ];

  options.custom-hm.services.dcal = {
    enable = lib.mkEnableOption "DankCalendar daemon for DMS calendar integration";
  };

  config = lib.mkIf cfg.enable {
    programs.dank-calendar = {
      enable = true;
      systemd.enable = true;
      quickshell.package = pkgs.unstable.quickshell;
    };
  };

}
