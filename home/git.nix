_: {
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

  # work config
  home.file."repos/betby/.gitconfig".text = ''
    [user]
      email = "181-a.timofeev@users.noreply.git.devspt.com"
      name = "Artem Timofeev"
  '';
}
