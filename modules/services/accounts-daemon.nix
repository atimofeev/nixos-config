{
  config,
  inputs,
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
    systemd.tmpfiles.rules = [
      "L+ /home/atimofeev/.face - - - - ${inputs.github-avatar.outPath}"
    ];
  };

}
