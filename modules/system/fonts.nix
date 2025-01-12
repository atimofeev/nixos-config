{ pkgs, vars, ... }: {

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "${vars.terminal.font_name}" ]; })
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # for Hyprpanel
  ];

}
