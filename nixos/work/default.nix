{ pkgs, config, vars, ... }: {
  imports = [
    ./ansible.nix
    ./docker.nix
    # ./gns3.nix # NOTE: probably still broken
    ./tofu.nix
    # ./vm.nix
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

  sops.secrets."work/officeVPNcreds".restartUnits =
    [ "openvpn-officeVPN.service" ];

  services.openvpn.servers = {

    officeVPN = {
      updateResolvConf = true;
      config = ''
        config /home/${vars.username}/secrets/officeVPN.conf
        auth-user-pass ${config.sops.secrets."work/officeVPNcreds".path}
      '';
    };

    AH-VPN = {
      # https://ipmilist.advancedhosters.com/
      config = "config /home/${vars.username}/secrets/AH-VPN.conf";
    };

  };

}
