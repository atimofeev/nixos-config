{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.work.kube-tools;
in
{
  options.custom.work.kube-tools.enable = lib.mkEnableOption "Kubernetes bundle";

  config = lib.mkIf cfg.enable {
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
      kubie
      minikube
      popeye
      stern
      talosctl
    ];
  };

}
