{
  username = "atimofeev";
  kb_layouts = "us,ru";
  shell = "fish";

  wallpaper = "${./assets/dark-shore.png}";

  terminal = {
    name = "kitty"; # should be executable
    font_name = "DejaVuSansMono";
    font_size = "12";
    editor = "nix run ~/repos/nixvim-config/"; # should be executable
  };

  hostUsers = {
    milaptop = [
      "atimofeev"
      "alice"
    ];
    zefir = [
      "atimofeev"
      "guest"
    ];
  };
}
