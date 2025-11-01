{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = [ pkgs.sops ];

  sops = {
    age.sshKeyPaths = [ "/home/${config.custom.hm-admin}/.ssh/id_ed25519" ];
    defaultSopsFile = ../../secrets/common.yaml;
    defaultSopsFormat = "yaml";
  };

}
