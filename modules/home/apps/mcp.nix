{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.mcp;
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

        aws-docs = {
          command = "docker";
          args = [
            "run"
            "--interactive"
            "--rm"
            "--env"
            "AWS_DOCUMENTATION_PARTITION=aws"
            "mcp/aws-documentation:latest"
          ];
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
