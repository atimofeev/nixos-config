{ pkgs, vars, ... }: {
  environment.systemPackages = with pkgs; [ sops ];
  sops = {
    age.sshKeyPaths = [ "/home/${vars.username}/.ssh/id_ed25519" ];
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    # validateSopsFiles = false; #???
  };
}
