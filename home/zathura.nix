# example config:
# https://github.com/RicArch97/nixos-config/blob/main/modules/desktop/apps/zathura.nix
{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
      adjust-open = "best-fit";
      selection-clipboard = "clipboard";
    };
    mappings = {
      ";" = "focus_inputbar ':'";
      b = "adjust_window best-fit";
      w = "adjust_window width";
      t = "recolor";
    };
  };
}
