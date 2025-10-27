{
  pkgs,
  vars,
  config,
  ...
}:
{
  programs.kitty = {
    enable = true;

    shellIntegration = {
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    settings = {
      # Font
      # TODO: font_name: move to global var
      inherit (vars.terminal) font_size;
      font_family = "DejaVuSansM Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # gotta go fast!
      repaint_delay = 8; # 150 FPS
      input_delay = 0; # Remove artificial input delay
      sync_to_monitor = "no"; # turn off vsync

      # Window
      # background_opacity = "0.8";
      hide_window_decorations = "yes";
      confirm_os_window_close = "2";

      enable_audio_bell = "no";
      copy_on_select = "yes";
      cursor_trail = 3;

      # Fix issues related to SSH (may break kitty functionality):
      term = "xterm-256color";

      scrollback_lines = "20000";
    };

    keybindings = {
      "ctrl+backspace" = "send_text all \\x17";
      "ctrl+delete" = "send_text all \\ed";
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+left" = "none"; # conflicts with nvim KBs
      "ctrl+shift+right" = "none";
    };

  };

  xdg.configFile."kitty/diff.conf" =
    let
      themeSource =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "kitty";
          rev = "4820b3ef3f4968cf3084b2239ce7d1e99ea04dda";
          sha256 = "sha256-uZSx+fuzcW//5/FtW98q7G4xRRjJjD5aQMbvJ4cs94U=";
        }
        + "/themes/diff-macchiato.conf";
    in
    {
      source = themeSource;
    };
}
