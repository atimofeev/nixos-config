{ config, ... }:
{

  custom-hm.user.shellAliases = {
    ls = "eza";
    ll = "eza --long";
    la = "eza --all --long";
    ld = "eza --list-dirs --long"; # show exact dir info
    lt = "eza --tree --level 2 --all";
    "l." = "eza --list-dirs .*"; # show only dotfiles
  };

  programs = {
    eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--color=always"
      ];
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

  };

}
