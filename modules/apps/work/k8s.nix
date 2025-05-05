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

}
