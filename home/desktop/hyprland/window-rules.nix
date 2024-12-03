_: {
  wayland.windowManager.hyprland.settings = {

    windowrule = [
      "float, pavucontrol|pwvucontrol"
      "float, nm-connection-editor|blueman-manager"
      "float, mpv"
      "float, zoom"
      "float, nvidia-settings"
    ];

    windowrulev2 = [
      "float, class:steam, title:^(Steam Settings|Sign in to Steam|Friends List|Steam - Browser)$"
      "float, class:firefox, title:^(About Mozilla Firefox)$"
      "float, class:Slack title:^(.*Huddle.*)$"
      "float, class:Slack title:^(.*Canvas.*)$"

      "opacity 1.0 override, onworkspace:s[true]"

      "workspace 10, class:^(Slack)$"

      # NOTE: trying to fix electron-wayland-intel issues
      "noanim, class:^(Slack|steam)$"

      "workspace special silent, class:^(spotify_player)$"
      "workspace special silent, class:^(org.telegram.desktop)$"

      "stayfocused, class:^(polkit-gnome-authentication-agent-1)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
      "noanim, class:^(polkit-gnome-authentication-agent-1)$"

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
