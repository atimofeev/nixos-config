{
  username = "atimofeev";
  shell = "fish";

  terminal = {
    name = "kitty"; # should be executable
    font_name = "DejaVuSansMono";
    font_size = "12";
    editor = "nix run ~/repos/nixvim-config/"; # should be executable
  };

}
