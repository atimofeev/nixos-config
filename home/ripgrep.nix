_: {

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--color-always"
      "--smart-case"
      "--no-line-number"
      "--hidden"
      "--glob=!.git/*"
      "--max-columns=150"
      "--max-columns-preview"
    ];
  };

}
