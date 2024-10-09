{ pkgs, ... }: {
  imports = [
    ./ansible.nix
    ./docker.nix
    # ./gns3.nix # NOTE: probably still broken
    ./tofu.nix
    # ./vm.nix
    ./vpn.nix
  ];

  environment.systemPackages = with pkgs; [
    # langs
    nodejs_18
    python3

    # cli tools
    awscli2
    nettools
    dig
    pwgen

    # k8s 
    minikube
    kubectl
    kubernetes-helm
    kubie # context & ns switching sub-shell
    popeye # cluster resource sanitizer

    # communication
    slack
    zoom-us
  ];

}
