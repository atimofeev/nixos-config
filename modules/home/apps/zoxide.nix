{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.zoxide;
in
{

  options.custom-hm.applications.zoxide = {
    enable = lib.mkEnableOption "zoxide bundle";
    package = lib.mkPackageOption pkgs "zoxide" { };
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      inherit (cfg) package;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };

}
