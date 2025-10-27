{ config, ... }:
{

  programs.yazi = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;
    keymap.mgr.prepend_keymap = [
      {
        on = [ "<Tab>" ];
        run = "tab_switch 1 --relative";
        desc = "Switch to the next tab";
      }
      {
        on = [ "<BackTab>" ];
        run = "tab_switch -1 --relative";
        desc = "Switch to the previous tab";
      }
    ];
  };

}
