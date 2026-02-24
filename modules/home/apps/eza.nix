{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.eza;
in
{

  options.custom-hm.applications.eza = {
    enable = lib.mkEnableOption "eza bundle";
    package = lib.mkPackageOption pkgs "eza" { };
  };

  config = lib.mkIf cfg.enable {

    custom-hm.user.shellAliases = {
      ls = "eza";
      ll = "eza --long";
      la = "eza --all --long";
      ld = "eza --list-dirs --long"; # show exact dir info
      lt = "eza --tree --level 2 --all";
      "l." = "eza --list-dirs .*"; # show only dotfiles
    };

    programs.eza = {
      enable = true;
      inherit (cfg) package;
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
