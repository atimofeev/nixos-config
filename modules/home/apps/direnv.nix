{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.direnv;
in
{

  options.custom-hm.applications.direnv = {
    enable = lib.mkEnableOption "direnv bundle";
    package = lib.mkPackageOption pkgs "direnv" { };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      inherit (cfg) package;
      enableBashIntegration = config.programs.bash.enable;
      # enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };

}
