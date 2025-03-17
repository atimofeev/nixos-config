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
          # try both styles of secret naming
          SA_SECRET_TOKEN1=$(kubectl get secret/$NAME-secret -n $NAMESPACE --context $CONTEXT -o jsonpath='{.data.token}' | base64 --decode)
          SA_SECRET_TOKEN2=$(kubectl get secret/$NAME-token -n $NAMESPACE --context $CONTEXT -o jsonpath='{.data.token}' | base64 --decode)
          CLUSTER_CA_CERT=$(kubectl config view --raw -o jsonpath="{.clusters[0].cluster.certificate-authority-data}")
          CLUSTER_ENDPOINT=$(kubectl config view --raw -o jsonpath="{.clusters[0].cluster.server}")

          echo "---
          apiVersion: v1
          kind: Config

          current-context: $CONTEXT

          contexts:
            - name: $CONTEXT
              context:
                cluster: $CONTEXT
                user: $NAME

          clusters:
            - name: $CONTEXT
              cluster:
                certificate-authority-data: $CLUSTER_CA_CERT
                server: $CLUSTER_ENDPOINT

          users:
            - name: $NAME
              user:
                token: $SA_SECRET_TOKEN1$SA_SECRET_TOKEN2

          " > ${config.home.homeDirectory}/$NAME_$CONTEXT.yaml
        ''
      ];
    };

  };
}
