{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.yazi;
in
{

  options.custom-hm.applications.yazi = {
    enable = lib.mkEnableOption "yazi bundle";
    package = lib.mkPackageOption pkgs "yazi" { };
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      inherit (cfg) package;
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
        {
          on = [
            "g"
            "?"
          ];
          run = "help";
          desc = "Open help";
        }
        {
          on = [
            "g"
            "."
          ];
          run = "spot";
          desc = "Spot hovered file";
        }
      ];
    };
  };

}
