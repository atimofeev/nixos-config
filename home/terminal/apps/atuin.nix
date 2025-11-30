{ config, ... }:
{

  programs.atuin = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;

    flags = [ "--disable-up-arrow" ];
    forceOverwriteSettings = true;

    settings = {
      dialect = "uk";
      enter_accept = true;
      search_mode = "fuzzy";
      style = "compact";
      update_check = false;
      workspaces = true;
    };
  };

}
