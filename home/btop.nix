{ pkgs, ... }: {
  # NOTE: configure: https://github.com/aristocratos/btop#configurability

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_macchiato";
      vim_keys = true;
      proc_gradient = false;
      proc_per_core = true;
    };
  };

  xdg.configFile."btop/themes/catppuccin_macchiato.theme".source =
    pkgs.fetchurl {
      url =
        "https://raw.githubusercontent.com/catppuccin/btop/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_macchiato.theme";
      hash = "sha256-+LGMyyF71OvBhIBqkdSaEssxK5zzfYuiMyJlOnisiFA=";
    };

}
