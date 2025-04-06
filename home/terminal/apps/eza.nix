{ lib, pkgs, config, ... }:
let
  themeName = "catppuccin.yml";

  themeSource = pkgs.fetchFromGitHub {
    owner = "eza-community";
    repo = "eza-themes";
    rev = "57149851f07b3ee6ca94f5fe3d9d552f73f8b8b4";
    sha256 = "sha256-vu6QLz0RvPavpD2VED25D2PJlHgQ8Yis+DnL+BPlvHw=";
  } + "/themes/${themeName}"; # path to theme in repo

  commonAliases = {
    ls = "eza";
    ll = "eza --long";
    la = "eza --all --long";
    ld = "eza --list-dirs --long"; # show exact dir info
    lt = "eza --tree --level 2 --all";
    "l." = "eza --list-dirs .*"; # show only dotfiles
  };
in {

  programs = {
    eza = {
      enable = true;
      extraOptions = [ "--group-directories-first" "--color=always" ];
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    bash =
      lib.mkIf config.programs.bash.enable { shellAliases = commonAliases; };
    fish =
      lib.mkIf config.programs.fish.enable { shellAliases = commonAliases; };
    nushell =
      lib.mkIf config.programs.nushell.enable { shellAliases = commonAliases; };
    zsh = lib.mkIf config.programs.zsh.enable { shellAliases = commonAliases; };
  };

  xdg.configFile."eza/theme.yml".source = themeSource;

}
