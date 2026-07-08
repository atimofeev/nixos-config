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
          command = "docker";
          args = [
            "run"
            "--interactive"
            "--rm"
            "--env"
            "GITHUB_PERSONAL_ACCESS_TOKEN"
            "ghcr.io/github/github-mcp-server"
          ];
        };

        kubernetes = {
          command = "npx";
          args = [
            "mcp-server-kubernetes"
            "--kubeconfig"
            "${config.home.homeDirectory}/.kube/homelab.yml"
          ];
        };

        nixos = {
          command = "docker";
          args = [
            "run"
            "--interactive"
            "--rm"
            "ghcr.io/utensils/mcp-nixos:2.4.1"
          ];
        };

        terraform = {
          command = "docker";
          args = [
            "run"
            "--interactive"
            "--rm"
            "hashicorp/terraform-mcp-server:0.5.1"
          ];
        };

      };
    };
  };

}
