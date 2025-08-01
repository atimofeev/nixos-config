{ config, ... }:
{

  programs.carapace = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    # enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  home.sessionVariables = {
    CARAPACE_BRIDGES = "fish,bash";
  };

}
