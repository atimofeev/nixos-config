{ inputs, pkgs, ... }:
{

  imports = [

    ./neovim

    # ./gnome
    # ./hyprland
    ./niri

    ./shell-aliases.nix
    ./xdg-mime.nix

  ];

  custom-hm = {

    user = {
      terminal = "kitty";
      editor = "nix run ~/repos/nixvim-config/";
      launcher.app = "vicinae";
      input = {
        repeat-delay = 275;
        repeat-rate = 35;
        mouse-sensitivity = -0.8;
        touchpad-sensitivity = -0.15;
        xkb = {
          layout = "us,ru";
          options = "grp:win_space_toggle";
        };
      };
      wallpaper.source = inputs.walls;
    };

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
      firefox.enable = true;
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
      imv.enable = true;
      k9s = {
        enable = true;
        package = pkgs.unstable.k9s;
      };
      mcp.enable = true;
      mpv.enable = true;
      nushell.enable = true;
      obsidian = {
        enable = true;
        package = pkgs.unstable.obsidian;
      };
      opencode.enable = true;
      pi-coding-agent = {
        enable = true;
        # package = pkgs.unstable.pi-coding-agent;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
      };
      qbittorrent.enable = true;
      ripgrep.enable = true;
      rofi.enable = true;
      spotify-player = {
        enable = true;
        package = pkgs.unstable.spotify-player;
      };
      ssh = {
        enable = true;
        agent = true;
        ssh-add-on-boot = true;
      };
      starship.enable = true;
      swappy.enable = true;
      tealdeer.enable = true;
      vcv-rack.enable = true;
      yazi.enable = true;
      zathura.enable = true;
      zen-browser.enable = true;
      zoxide.enable = true;
    };

    services = {
      cliphist.enable = true;
      dank-material-shell.enable = true;
      hypridle.enable = false;
      hyprpanel.enable = false;
      hyprpaper.enable = false;
      hyprsunset.enable = false;
      polkit-gnome.enable = true;
      syncthing.enable = true;
      vicinae = {
        enable = true;
        package = pkgs.unstable.vicinae;
      };
    };

    system = {
      nix-index.enable = true;
    };

  };

}
