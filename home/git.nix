{ ... }: {
  programs.git = {
    enable = true;
    userName = "Artem Timofeev";
    userEmail = "39891735+atimofeev@users.noreply.github.com";
    ignores = [ "*.swp" ];
    includes = [{
      path = "~/repos/betby/.gitconfig";
      condition = "gitdir:~/repos/betby/";
    }];
    # cat ~/repos/betby/.gitconfig 
    # [user]
    # 	email = "181-a.timofeev@users.noreply.git.devspt.com"
  };
}
