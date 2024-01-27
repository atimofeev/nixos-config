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
}
