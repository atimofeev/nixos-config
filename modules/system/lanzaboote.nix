{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom.system.lanzaboote;
in
{

  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.custom.system.lanzaboote = {
    enable = lib.mkEnableOption "lanzaboote bundle";
  };

  config = lib.mkIf cfg.enable {

    boot = {
      initrd.systemd.enable = true;
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
        autoGenerateKeys.enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };

}
