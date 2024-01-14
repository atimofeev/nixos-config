{ ... }: {
  programs.git = {
    enable = true;
    userName = "Artem Timofeev";
    userEmail = "39891735+atimofeev@users.noreply.github.com";
    ignores = [ "*.swp" ];
  };
}
