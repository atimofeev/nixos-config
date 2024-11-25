{
  nix.stateVersion = "24.05";
  username = "atimofeev";
  hostname = "milaptop";
  kb_layouts = "us,ru";
  tz_name = "Europe/Podgorica";
  shell = "fish";

  wallpaper = "${./assets/dark-shore.png}";

  terminal = {
    name = "kitty"; # should be executable
    font_name = "DejaVuSansMono";
    font_size = "12";
    editor = "nvim"; # should be executable
  };
}
