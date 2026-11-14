{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.mcp;
  awsProxy = pkgs.writeShellApplication {
    name = "aws-mcp-proxy";
    runtimeInputs = [
      pkgs.awscli2
      pkgs.uv
    ];
    text = ''
      profiles="$(aws configure list-profiles)"
      AWS_MCP_PROXY_PROFILES="''${profiles//$'\n'/ }"
      default_profile="''${AWS_PROFILE:-''${AWS_DEFAULT_PROFILE:-}}"
      if [[ -n "$default_profile" ]]; then
        AWS_MCP_PROXY_PROFILES="$default_profile $AWS_MCP_PROXY_PROFILES"
      fi
      export AWS_MCP_PROXY_PROFILES
      exec uvx "$@"
    '';
  };
  # The server requires a default context; never default to a real cluster.
  kubernetesBlankConfig = pkgs.writeText "mcp-kubeconfig-blank.json" (
    builtins.toJSON {
      apiVersion = "v1";
      clusters = [
        {
          cluster.server = "http://127.0.0.1:1";
          name = "mcp-blank-cluster";
        }
      ];
      contexts = [
        {
          context.cluster = "mcp-blank-cluster";
          name = "mcp-blank-context";
        }
      ];
      current-context = "mcp-blank-context";
      kind = "Config";
      users = [ ];
    }
  );
in
{

  options.custom-hm.applications.mcp = {
    enable = lib.mkEnableOption "MCP servers";
  };

  config = lib.mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = {

        aws = {
          args = [
            "--python"
            "${pkgs.python3}/bin/python3"
            "mcp-proxy-for-aws-cli==1.8.0"
            "https://aws-mcp.us-east-1.api.aws/mcp"
            "--skip-auth"
          ];
          command = lib.getExe awsProxy;
          directTools = false;
        };

        github = {
          type = "http";
          url = "https://api.githubcopilot.com/mcp/";
          auth = "bearer";
          bearerToken = "!gh auth token";
          directTools = false;
        };

        kubernetes = {
          args = [
            "--yes"
            "kubernetes-mcp-server@0.1.3"
          ];
          command = "npx";
          directTools = false;
          env = {
            KUBECONFIG = lib.concatStringsSep ":" [
              kubernetesBlankConfig
              "${config.home.homeDirectory}/.kube/config"
              "${config.home.homeDirectory}/.kube/homelab.yaml"
            ];
          };
        };

        nixos = {
          command = "docker";
          args = [
            "run"
            "--interactive"
            "--rm"
            "ghcr.io/utensils/mcp-nixos:3.0.1"
          ];
        };

        paperless = {
          type = "http";
          url = "http://127.0.0.1:3001/mcp";
        };

        sidero-docs = {
          type = "http";
          url = "https://docs.siderolabs.com/mcp";
          directTools = false;
        };

        terraform = {
          command = "docker";
          args = [
            "run"
            "--interactive"
            "--rm"
            "hashicorp/terraform-mcp-server:0.5.1"
          ];
          directTools = false;
        };

      };
    };
  };

}
