{ pkgs, ... }: {

  # TODO: try https://github.com/a1994sc/krew2nix

  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [ helm-diff helm-git ];
    })
    kubectl
    kubectl-cnpg
    kubectl-df-pv
    kubectl-doctor
    kubectl-graph
    kubectl-klock
    kubectl-ktop
    kubectl-node-shell
    kubectl-view-allocations
    kubectl-view-secret
    kubie # context & ns switching sub-shell
    minikube
    popeye # cluster resource sanitizer
    stern # pod/container log tailing
    talosctl
  ];

  # Resolve *.homelab domain to minikube
  services = {
    dnsmasq = {
      enable = true;
      settings = {
        address = "/homelab/192.168.49.2";
        listen-address = "127.0.1.53";
      };
    };
    resolved.extraConfig = # conf
      ''
        [Resolve]
        DNSStubListener=no
        DNS=127.0.1.53
        Domains=~homelab
      '';
  };

}
