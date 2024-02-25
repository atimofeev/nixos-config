{ ... }: {
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
    };
  };
}
