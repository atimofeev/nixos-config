_: {

  imports = [ ./helm.nix ./kubeconfig.nix ];

  programs.k9s.plugin.plugins = {

    # TODO: test
    #--- Create debug container for selected pod in current namespace
    # See https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container
    debug-container = {
      shortCut = "Ctrl-D";
      description = "debug-container";
      confirm = true;
      scopes = [ "containers" ];
      command = "sh";
      args = [
        "-c"
        "kubectl debug -it -n=$NAMESPACE $POD --target=$NAME --image=nicolaka/netshoot:v0.11 --share-processes -- bash"
      ];
    };

    open-ingress = {
      shortCut = "Ctrl-O";
      description = "open-ingress";
      background = true;
      scopes = [ "ing" ];
      command = "bash";
      args = [
        "-c"
        "xdg-open $(kubectl get ing -n $NAMESPACE $NAME --context $CONTEXT -o jsonpath='https://{.spec.rules[0].host}')"
      ];
    };

    copy-name = {
      shortCut = "Ctrl-N";
      description = "copy-name";
      background = true;
      scopes = [ "all" ];
      command = "sh";
      args = [ "-c" "echo -n $NAME | wl-copy" ];
    };

  };
}
