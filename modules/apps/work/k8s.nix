{ pkgs, ... }:
{

  # TODO: try https://github.com/a1994sc/krew2nix

  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
        helm-git
      ];
    })
    cmctl
    kind
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

  networking.extraHosts = ''
    172.18.255.1 argocd.k8s.homelab
    172.18.255.1 convertx.k8s.homelab
    172.18.255.1 stirling-pdf.k8s.homelab
    172.18.255.1 prometheus.k8s.homelab
    172.18.255.1 grafana.k8s.homelab
    172.18.255.1 alertmanager.k8s.homelab
  '';

  networking.firewall.checkReversePath = "loose"; # NOTE: fixed inter-node communication

  # services.resolved = {
  #   domains = [ "homelab.com" ];
  #   fallbackDns = [ "172.18.0.4#5353" ];
  # };

  # # Resolve *.homelab domain to minikube
  # services = {
  #   dnsmasq = {
  #     enable = true;
  #     settings = {
  #       address = "/homelab/192.168.49.2";
  #       listen-address = "127.0.1.53";
  #     };
  #   };
  #   resolved.extraConfig = # conf
  #     ''
  #       [Resolve]
  #       DNSStubListener=no
  #       DNS=127.0.1.53
  #       Domains=~homelab
  #     '';
  # };

}
