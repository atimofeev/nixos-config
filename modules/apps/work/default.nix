{ pkgs, ... }: {
  imports = [
    # ./gns3.nix # NOTE: probably still broken
    # ./vm.nix
    ./ansible.nix
    ./jira.nix
    ./nitrokey.nix
    ./tofu.nix
    ./vpn.nix
  ];

  environment.systemPackages = with pkgs; [
    # langs
    nodejs_18
    python3

    # cli tools
    awscli2
    vault
    nettools
    dig
    pwgen
    vault-kv-mv

    # k8s 
    minikube
    kubectl
    krew # TODO: requires additional setup; see `krew list`
    # use https://github.com/eigengrau/krew2nix ?
    kubernetes-helm
    kubie # context & ns switching sub-shell
    popeye # cluster resource sanitizer

    # communication
    slack
    zoom-us
  ];

  # fix for WPA2-Enterprise PEAP
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF =
    pkgs.writeText "openssl.cnf" ''
      openssl_conf = openssl_init
      [openssl_init]
      ssl_conf = ssl_sect
      [ssl_sect]
      system_default = system_default_sect
      [system_default_sect]
      Options = UnsafeLegacyRenegotiation
      [system_default_sect]
      CipherString = Default:@SECLEVEL=0
    '';

}
