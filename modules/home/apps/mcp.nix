{
  config,
  lib,
  ...
}:
let
  cfg = config.custom-hm.applications.mcp;
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
          command = "npx";
          args = [ "mcp-server-kubernetes" ];
          directTools = false;
          env = {
            K8S_CONTEXT = "mcp-none";
            KUBECONFIG_PATH = "${config.home.homeDirectory}/.kube/config";
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
