_: {
  programs.k9s.plugin.plugins = {

    # TODO: rewrite
    helmrelease-toggle = {
      shortCut = "Shift-T";
      description = "Toggle: resume|suspend";
      confirm = true;
      background = true;
      scopes = [ "helmreleases" ];
      command = "bash";
      args = [
        "-c"
        ''
          >-
          suspended=$(kubectl --context $CONTEXT get helmreleases -n $NAMESPACE $NAME -o=custom-columns=TYPE:.spec.suspend | tail -1);
          verb=$([ $suspended = "true" ] && echo "resume" || echo "suspend");
          flux
          $verb helmrelease
          --context $CONTEXT
          -n $NAMESPACE $NAME
          | less -K
        ''
      ];
    };

    # TODO: rewrite
    get-suspended-helmreleases = {
      shortCut = "Shift-S";
      description = "Get Suspended helmreleases";
      scopes = [ "helmrelease" ];
      command = "sh";
      args = [
        "-c"
        ''
          >-
          kubectl get
          --context $CONTEXT
          --all-namespaces
          helmreleases.helm.toolkit.fluxcd.io -o json
          | jq -r '.items[] | select(.spec.suspend==true) | [.metadata.namespace,.metadata.name,.spec.suspend] | @tsv'
          | most
        ''
      ];
    };

    # TODO: verify operation
    # Issues a helm delete --purge for the resource associated with the selected pod
    helm-purge = {
      shortCut = "Ctrl-P";
      description = "Helm Purge";
      confirm = true;
      background = true;
      scopes = [ "po" ];
      command = "kubectl";
      args = [ "purge" "$NAMESPACE" "$NAME" ];
    };

  };
}
