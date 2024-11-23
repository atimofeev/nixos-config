{ config, ... }: {
  programs.git = {
    enable = true;
    userName = "Artem Timofeev";
    userEmail = "39891735+atimofeev@users.noreply.github.com";
    ignores = [ "*.swp" ".null-ls_*" ];
    extraConfig = { pull.rebase = true; };
    includes = [{
      path = "~/repos/betby/.gitconfig";
      condition = "gitdir:~/repos/betby/";
    }];
  };

  sops.secrets."work/gitlab-config" = {
    path = "${config.home.homeDirectory}/repos/betby/.gitconfig";
  };

}
