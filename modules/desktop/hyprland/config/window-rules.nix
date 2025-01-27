_: {
  wayland.windowManager.hyprland.settings = {

    windowrulev2 = [
      "float, class:^(pavucontrol|pwvucontrol)$"
      "float, class:^(nm-connection-editor|blueman-manager)$"
      "float, class:nvidia-settings"
      "float, class:mpv"
      "float, class:zoom"
      "float, title:Protontricks"
      "float, class:xdg-desktop-portal-gtk"

      "float, class:steam"
      "tile, class:steam, title:^(Steam)$"

      "float, class:electron, title:^(Open.*)$"

      "workspace 10, class:Slack"
      "float, class:^(Slack|slack)$ title:^(.*Huddle.*|.*Canvas.*|Open File.*)$"

      "opacity 1.0 override, onworkspace:s[true]"
      "workspace special, class:spotify_player"
      "workspace special, class:org.telegram.desktop"

      "float, class:firefox, title:^(About Mozilla Firefox|Page Info.*)$"
      # Picture-in-a-Picture (PIP) rules: Oddly, some need re-duplication.  This is because the window for
      # PIP changes after on first launch, and will not inherit the rules...
      "opacity 1.0 override, title:^(Firefox|Picture-in-Picture)$"
      "pin, title:^(Firefox|Picture-in-Picture)$"
      "float, title:^(Firefox|Picture-in-Picture)$"
      "size 25% 25%, title:^(Firefox|Picture-in-Picture)$"
      "move 72% 7%, title:^(Firefox|Picture-in-Picture)$"
    ];

  };
}
