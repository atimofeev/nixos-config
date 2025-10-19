{ pkgs, config, ... }:
let
  themeName = "catppuccin-macchiato-blue.toml";

  themeSource =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "yazi";
      rev = "043ffae14e7f7fcc136636d5f2c617b5bc2f5e31";
      sha256 = "sha256-zkL46h1+U9ThD4xXkv1uuddrlQviEQD3wNZFRgv7M8Y=";
    }
    + "/themes/macchiato/${themeName}"; # path to theme in repo

in
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

  xdg.configFile."yazi/theme.toml".source = themeSource;
}
