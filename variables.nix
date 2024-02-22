{
  nix.stateVersion = "23.11";
  username = "atimofeev";
  hostname = "milaptop";
  kb_layouts = "us,ru";
  tz_name = "Asia/Tbilisi";
  shell = "fish";

  terminal = {
    name = "kitty"; # should be executable
    font_name = "DejaVuSansMono";
    font_size = "12";
    editor = "nvim"; # should be executable
  };
}
