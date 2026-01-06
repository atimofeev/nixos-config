{
  lib,
  config,
  ...
}:
let
  commonAliases = {
    ls = "eza";
    ll = "eza --long";
    la = "eza --all --long";
    ld = "eza --list-dirs --long"; # show exact dir info
    lt = "eza --tree --level 2 --all";
    "l." = "eza --list-dirs .*"; # show only dotfiles
  };
in
{

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

    bash = lib.mkIf config.programs.bash.enable { shellAliases = commonAliases; };
    fish = lib.mkIf config.programs.fish.enable { shellAliases = commonAliases; };
    nushell = lib.mkIf config.programs.nushell.enable { shellAliases = commonAliases; };
    zsh = lib.mkIf config.programs.zsh.enable { shellAliases = commonAliases; };
  };

}
