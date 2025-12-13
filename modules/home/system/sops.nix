{
  config,
  inputs,
  lib,
  osConfig,
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
  };

}
