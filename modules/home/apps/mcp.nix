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

        terraform = {
          command = "docker";
          args = [
            "run"
            "-i"
            "--rm"
            "hashicorp/terraform-mcp-server:0.5.1"
          ];
        };

        kubernetes = {
          command = "npx";
          args = [
            "mcp-server-kubernetes"
            "--kubeconfig"
            "~/.kube/homelab.yml"
          ];
        };

        nixos = {
          command = "docker";
          args = [
            "run"
            "-i"
            "--rm"
            "ghcr.io/utensils/mcp-nixos:2.4.1"
          ];
        };

      };
    };
  };

}

