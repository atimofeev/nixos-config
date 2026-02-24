{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.carapace;
in
{

  options.custom-hm.applications.carapace = {
    enable = lib.mkEnableOption "carapace bundle";
    package = lib.mkPackageOption pkgs "carapace" { };
  };

  config = lib.mkIf cfg.enable {

    programs.carapace = {
      enable = true;
      inherit (cfg) package;
      enableBashIntegration = config.programs.bash.enable;
      # enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    home.sessionVariables = {
      CARAPACE_BRIDGES = "fish,bash";
    };

  };

}
