{ inputs, osConfig, ... }: {

  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age = { inherit (osConfig.sops.age) sshKeyPaths; };
    inherit (osConfig.sops) defaultSopsFile;
    inherit (osConfig.sops) defaultSopsFormat;
  };

}
