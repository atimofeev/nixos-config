{ config, ... }: {
  programs.k9s.plugin.plugins = {

    generate-kubeconfig = {
      shortCut = "Shift-K";
      description = "Get config";
      background = true;
      scopes = [ "serviceaccount" ];
      command = "bash";
      args = [
        "-c"
        ''
          server=$(kubectl config view --minify --output 'jsonpath={.clusters[0].cluster.server}')
          ca=$(kubectl get secret/$NAME-secret -n $NAMESPACE --context $CONTEXT -o jsonpath='{.data.ca\.crt}')
          token=$(kubectl get secret/$NAME-secret -n $NAMESPACE --context $CONTEXT -o jsonpath='{.data.token}' | base64 --decode)
          ns="default"

          echo "---
          apiVersion: v1
          kind: Config

          current-context: $CONTEXT

          contexts:
            - name: $CONTEXT-$NAME
              context:
                user: $NAME
                cluster: $CONTEXT
                namespace: $ns

          clusters:
            - name: $CONTEXT
              cluster:
                server: $server
                certificate-authority-data: $ca

          users:
            - name: $NAME
              user:
                token: $token

          " > ${config.home.homeDirectory}/$NAME_$CONTEXT.yaml
        ''
      ];
    };

  };
}
