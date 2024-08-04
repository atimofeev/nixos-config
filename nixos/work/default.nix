{ pkgs, vars, ... }: {
  imports = [ ./ansible.nix ./gns3.nix ./tofu.nix ];

  users.users.${vars.username}.extraGroups = [ "docker" "libvirtd" ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    awscli2
    nodejs_18

    # containers
    # TODO: move to root-less podman
    # podman-desktop
    # podman-compose
    # podman-tui 
    docker-compose
    dive

    # k8s 
    minikube
    kubectl
    kubernetes-helm
    kubie

    # VMs
    gnome.gnome-boxes

    # communication
    slack
    zoom-us
  ];
}
