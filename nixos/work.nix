{ pkgs, vars, ... }: {
  imports = [ ./gns3.nix ];
  virtualisation.docker.enable = true;
  users.users.${vars.username}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    ansible
    sshpass # ansible: ssh auth with pass
    terraform
    minikube
    kubectl
    kubernetes-helm
    slack
  ];

  # Pin ansible version
  nixpkgs.config = {
    packageOverrides = pkgs: {
      ansible = pkgs.ansible.overrideAttrs (oldAttrs: {
        version = "2.11.6";
        src = pkgs.fetchFromGitHub {
          owner = "ansible";
          repo = "ansible";
          rev = "v2.11.6";
          sha256 = "sha256-+ljma9q1tDo0/0YQmjKO2R756BRydFgAu+2wDu+ARto=";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs
          ++ [ pkgs.python311Packages.hvac ];
      });
    };
  };

}
