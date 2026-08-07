{ inputs, pkgs, ... }:
{

  imports = [

    ../atimofeev/neovim
    ../atimofeev/shell-aliases.nix

  ];

  custom-hm = {

    user.editor = "nix run github:atimofeev/nixvim-config";

    applications = {
      ai-skills = {
        enable = true;
        antigravity-awesome-skills = [
          "aws-cost-cleanup"
          "aws-cost-optimizer"
          "aws-iam-best-practices"
          "bash-defensive-patterns"
          "bash-pro"
          "cicd-automation-workflow-automate"
          "cloud-architect"
          "cloud-devops"
          "deployment-engineer"
          "deployment-pipeline-design"
          "deployment-procedures"
          "docker-expert"
          "gitlab-ci-patterns"
          "gitops-workflow"
          "grafana-dashboards"
          "helm-chart-scaffolding"
          "hybrid-cloud-architect"
          "k8s-manifest-generator"
          "kubernetes-architect"
          "kubernetes-deployment"
          "prometheus-configuration"
          "secrets-management"
          "terraform-aws-modules"
          "terraform-infrastructure"
        ];
        hashicorp-terraform-skills.enable = true;
        nixomatic-skill.enable = true;
        terraform-skill.enable = true;
        terramate-skills.enable = true;
      };
      atuin = {
        enable = true;
        package = pkgs.unstable.atuin;
        sync = {
          enable = true;
          address = "https://atuin.prosto.dev";
        };
      };
      bash.enable = true;
      bat.enable = true;
      btop.enable = true;
      carapace.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fish.enable = true;
      gemini-cli = {
        enable = true;
        package = pkgs.unstable.gemini-cli;
      };
      git.enable = true;
      htop = {
        enable = true;
        package = pkgs.htop-vim;
      };
      mcp.enable = true;
      nushell.enable = true;
      opencode.enable = true;
      pi-coding-agent = {
        enable = true;
        # package = pkgs.unstable.pi-coding-agent;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
      };
      ripgrep.enable = true;
      ssh = {
        enable = true;
        agent = true;
        ssh-add-on-boot = true;
      };
      starship.enable = true;
      tealdeer.enable = true;
      yazi.enable = true;
      zoxide.enable = true;
    };

    system = {
      nix-index.enable = true;
    };

  };

}
