{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.system.sops;
in
{

  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.custom.system.sops = {
    enable = lib.mkEnableOption "sops bundle";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sops ];

    sops = {
      age.sshKeyPaths = [ "/home/${config.custom.hm-admin}/.ssh/id_ed25519" ];
      defaultSopsFile = ../../secrets/common.yaml;
      defaultSopsFormat = "yaml";
    };
  };

}
