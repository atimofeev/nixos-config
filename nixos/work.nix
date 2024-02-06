{ pkgs, vars, ... }: {
  virtualisation.docker.enable = true;
  users.users.${vars.username}.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker-compose
    ansible
    terraform
    minikube
    kubectl
    kubernetes-helm
    k9s
    slack
  ];
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
      });
    };
  };
}
