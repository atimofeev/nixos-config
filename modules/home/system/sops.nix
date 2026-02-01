{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.system.sops;
  osEnabled = (osConfig ? sops) && ((osConfig.sops.defaultSopsFile or null) != null);
in
{

  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  options.custom-hm.system.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osEnabled;
      description = "Enable sops integration. Defaults to enabled if system sops is configured.";
    };
  };

  config = lib.mkIf cfg.enable {

    sops = {
      age = { inherit (osConfig.sops.age) sshKeyPaths; };
      inherit (osConfig.sops) defaultSopsFile defaultSopsFormat;
    };

    custom-hm.user.shellAliases = {
      sops-common = "SOPS_AGE_KEY=$(${lib.getExe pkgs.ssh-to-age} -private-key -i ~/.ssh/id_ed25519) sops ~/repos/nixos-config/secrets/common.yaml";
      sops-host = "SOPS_AGE_KEY=$(${lib.getExe pkgs.ssh-to-age} -private-key -i ~/.ssh/id_ed25519) sops ~/repos/nixos-config/secrets/${osConfig.networking.hostName}.yaml";
    };

  };

}
