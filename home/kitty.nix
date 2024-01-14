{ ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      # Font
      # TODO: move to global var
      font_size = "12";
      font_family = "DejaVuSansM Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Window
      background_opacity = "0.8";
      hide_window_decorations = "yes";
      scrollback_lines = "10000";
      confirm_os_window_close = "2";

      copy_on_select = "yes";

      #background_opacity = toString default.terminal.opacity;
    };
    keybindings = {
      "ctrl+backspace" = "send_text all \\x17";
      "ctrl+delete" = "send_text all \\ed";
      "ctrl+v" = "paste_from_clipboard";
    };

    # TODO: move to global var
    theme = "Tokyo Night Moon";
  };
}
