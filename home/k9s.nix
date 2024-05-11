{ pkgs, libx, ... }:
let
  themeName = "catppuccin-macchiato.yaml";
  themeSource = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "590a762110ad4b6ceff274265f2fe174c576ce96";
    sha256 = "sha256-EBDciL3F6xVFXvND+5duT+OiVDWKkFMWbOOSruQ0lus=";
  } + "/dist/${themeName}"; # path to theme in repo
in {

  programs.k9s = {
    enable = true;
    skin = libx.formats.fromYAML themeSource;
  };

  # FIX:
  xdg.configFile."k9s/aliases.yaml".text = ''
    ---
    aliases:
      de: deployment
  '';

  # FIX: 
  xdg.configFile."k9s/plugins.yaml".text = ''
    ---
    plugins:
      log-less:
        shortCut: Shift-L
        description: "logs|less"
        scopes:
          - po
        command: bash
        background: false
        args:
          - -c
          - '"$@" | less'
          - dummy-arg
          - kubectl
          - logs
          - $NAME
          - -n
          - $NAMESPACE
          - --context
          - $CONTEXT
      log-less-container:
        shortCut: Shift-L
        description: "logs|less"
        scopes:
          - containers
        command: bash
        background: false
        args:
          - -c
          - '"$@" | less'
          - dummy-arg
          - kubectl
          - logs
          - -c
          - $NAME
          - $POD
          - -n
          - $NAMESPACE
          - --context
          - $CONTEXT

      log-less-timestamp:
        shortCut: Ctrl-T
        description: "timestamp: logs|less"
        scopes:
          - po
        command: zsh
        background: false
        args:
          - -c
          - '"$@" | less'
          - dummy-arg
          - kubectl
          - logs
          - $NAME
          - -n
          - $NAMESPACE
          - --context
          - $CONTEXT
          - --kubeconfig
          - $KUBECONFIG
          - --timestamps=true

      log-to-file:
        shortCut: Ctrl-P
        description: "Save log to file"
        scopes:
          - po
        command: sh
        background: true
        args:
          - -c
          - kubectl logs $NAME -n $NAMESPACE --context $CONTEXT > $NAME.log

      #--- Create debug container for selected pod in current namespace
      # See https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container
      debug-container:
        shortCut: Shift-D
        description: Add debug container
        scopes:
          - containers
        command: bash
        background: false
        confirm: true
        args:
          - -c
          - "kubectl debug -it -n=$NAMESPACE $POD --target=$NAME --image=nicolaka/netshoot:v0.11 --share-processes -- bash"

      # watch events on selected resources
      # requires linux "watch" command
      # change '-n' to adjust refresh time in seconds
      watch-events:
        shortCut: Shift-E
        confirm: false
        description: Get Events
        scopes:
          - all
        command: sh
        background: false
        args:
          - -c
          - "watch -n 5 kubectl get events --context $CONTEXT --namespace $NAMESPACE --field-selector involvedObject.name=$NAME"

      edit-secret:
        shortCut: Ctrl-X
        confirm: false
        description: "Edit Decoded Secret"
        scopes:
          - secrets
        command: kubectl
        background: false
        args:
          - modify-secret
          - --namespace
          - $NAMESPACE
          - --context
          - $CONTEXT
          - $NAME

      open:
        shortCut: Ctrl-O
        confirm: false
        description: "Open ingress"
        scopes:
          - ing
        command: sh
        background: true
        args:
          - -c
          - "open $(kubectl get ing -n $NAMESPACE $NAME --context $CONTEXT -o jsonpath='https://{.spec.rules[0].host}')"

      # get all resources in a namespace using the krew get-all plugin
      get-all:
        shortCut: g
        confirm: false
        description: get-all
        scopes:
          - all
        command: sh
        background: false
        args:
          - -c
          - "kubectl get-all -n $NAMESPACE --context $CONTEXT | less"

      disable-cronjob:
        shortCut: Ctrl-N
        description: never run (31 Feb)
        scopes:
          - cj
        command: kubectl
        background: false
        confirm: true
        args:
          - patch
          - cronjob
          - $NAME
          - -n
          - $NAMESPACE
          - -p
          - '{"spec" : {"schedule" : "0 0 31 2 *"}}'

      # View user-supplied values when the helm chart was created
      helm-values:
        shortCut: v
        confirm: false
        description: Values
        scopes:
          - helm
        command: sh
        background: false
        args:
          - -c
          - "helm get values $COL-NAME -n $NAMESPACE --kube-context $CONTEXT | less -K"

      raw-logs-follow:
        shortCut: Ctrl-L
        description: Live full logs
        scopes:
          - pods
        command: bash
        background: false
        args:
          - -c
          - '"$@" | pretty_logs'
          - dummy-arg
          - kubectl
          - logs
          - -f
          - $NAME
          - -n
          - $NAMESPACE
          - --context
          - $CONTEXT

      toggle-helmrelease:
        shortCut: Shift-T
        confirm: true
        scopes:
          - helmreleases
        description: Toggle to suspend or resume a HelmRelease
        command: bash
        background: false
        args:
          - -c
          - >-
            suspended=$(kubectl --context $CONTEXT get helmreleases -n $NAMESPACE $NAME -o=custom-columns=TYPE:.spec.suspend | tail -1);
            verb=$([ $suspended = "true" ] && echo "resume" || echo "suspend");
            flux
            $verb helmrelease
            --context $CONTEXT
            -n $NAMESPACE $NAME
            | less -K

      get-suspended-helmreleases:
        shortCut: Shift-S
        confirm: false
        description: Suspended Helm Releases
        scopes:
          - helmrelease
        command: sh
        background: false
        args:
          - -c
          - >-
            kubectl get
            --context $CONTEXT
            --all-namespaces
            helmreleases.helm.toolkit.fluxcd.io -o json
            | jq -r '.items[] | select(.spec.suspend==true) | [.metadata.namespace,.metadata.name,.spec.suspend] | @tsv'
            | most

      raw-logs-follow-container:
        shortCut: Ctrl-L
        description: logs -f
        scopes:
          - containers
        command: kubectl
        background: false
        args:
          - logs
          - -f
          - $NAME
          - -n
          - $NAMESPACE
          - --context
          - $CONTEXT
          - --kubeconfig
          - $KUBECONFIG
      log-less-container-timestamp:
        shortCut: Ctrl-T
        description: "timestamp: logs|less"
        scopes:
          - containers
        command: zsh
        background: false
        args:
          - -c
          - '"$@" | less'
          - dummy-arg
          - kubectl
          - logs
          - -c
          - $NAME
          - $POD
          - -n
          - $NAMESPACE
          - --context
          - $CONTEXT
          - --kubeconfig
          - $KUBECONFIG
          - --timestamps=true

      copy-name:
        shortCut: Ctrl-N
        description: Copy name
        scopes:
          - po
        command: sh
        background: false
        args:
          - -c
          - "echo -n $NAME | xclip -sel clip"

      # Issues a helm delete --purge for the resource associated with the selected pod
      helm-purge:
        shortCut: Ctrl-P
        description: Helm Purge
        scopes:
          - po
        command: kubectl
        background: true
        args:
          - purge
          - $NAMESPACE
          - $NAME
  '';
}
