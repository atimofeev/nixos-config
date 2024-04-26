{ pkgs, vars, ... }: {
  imports = [ ./gns3.nix ];

  users.users.${vars.username}.extraGroups = [ "docker" "libvirtd" ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  programs.virt-manager.enable = true;
  # TODO: move this into home-manager
  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = [ "qemu:///system" ];
  #     uris = [ "qemu:///system" ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-desktop
    # podman-tui # NOTE: useless without podman itself
    ansible
    sshpass # ansible: ssh auth with pass
    terraform
    minikube
    kubectl
    kubernetes-helm
    slack
    zoom
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
