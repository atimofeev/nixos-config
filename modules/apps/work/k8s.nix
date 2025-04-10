{ pkgs, ... }: {

  # TODO: try https://github.com/a1994sc/krew2nix

  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = [ kubernetes-helmPlugins.helm-diff ];
    })
    kubectl
    kubectl-cnpg
    kubectl-node-shell
    kubie # context & ns switching sub-shell
    minikube
    popeye # cluster resource sanitizer
  ];

}
