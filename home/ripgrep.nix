_: {

  programs.ripgrep = {
    enable = true;
    arguments = [
      # "--color=always" # conflict with telescope.nvim
      "--smart-case"
      "--no-line-number"
      "--hidden"
      "--glob=!.git/*"
      "--max-columns=150"
      "--max-columns-preview"
    ];
  };

}
