{ config, ... }: {
  programs.k9s.plugin.plugins = {

    generate-kubeconfig = {
      shortCut = "Shift-K";
      description = "Get config";
      # background = true;
      scopes = [ "serviceaccount" ];
      command = "bash";
      args = [
        "-c"
        ''
          >-
          server=$(kubectl config view --minify --output 'jsonpath={.clusters[0].cluster.server}')
          ca=$(kubectl get secret/$NAME-secret -n $NAMESPACE --context $CONTEXT -o jsonpath='{.data.ca\.crt}')
          token=$(kubectl get secret/$NAME-secret -n $NAMESPACE --context $CONTEXT -o jsonpath='{.data.token}' | base64 --decode)

          echo "
          apiVersion: v1
          kind: Config
          clusters:
          - name: $CONTEXT
            cluster:
              server: $server
              certificate-authority-data: $ca
          users:
          - name: $NAME
            user:
              token: $token
          contexts:
          - name: $CONTEXT-$NAME
            context:
              user: $NAME
              cluster: $CONTEXT
              namespace: $NAMESPACE
          current-context: $CONTEXT
          " > ${config.home.homeDirectory}/$NAME_$CONTEXT.yaml
        ''
      ];
    };

  };
}
