{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "Artem Timofeev";
    userEmail = "39891735+atimofeev@users.noreply.github.com";
    ignores = [
      "*.swp"
      ".null-ls_*"
      ".terraform*"
      "terraform.tfstate*"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
    includes = [
      {
        path = "~/repos/betby/.gitconfig";
        condition = "gitdir:~/repos/betby/";
      }
    ];
  };

  sops.secrets."work/gitlab-config" = {
    path = "${config.home.homeDirectory}/repos/betby/.gitconfig";
  };

}
