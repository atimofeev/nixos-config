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
      "float, class:steam, title:^(Steam Settings|Sign in to Steam)$"
      "float, class:firefox, title:^(About Mozilla Firefox)$"
      "float, title:^(.*Huddle.*)$"

      "opacity 1.0 override, onworkspace:s[true]"

      "workspace 10, class:^(Slack)$"
      "workspace special silent, class:^(spotify_player)$"
      "workspace special silent, class:^(org.telegram.desktop)$"
      # FIX: telegram media is half-broken in special
      # "workspace 1, class:^(org.telegram.desktop)$ title:^(Media viever)$"
      # "fullscreen, class:^(org.telegram.desktop)$ title:^(Media viever)$"
      # "workspace unset, class:^(org.telegram.desktop)$ title:^(Media viever)$"
      # "float, class:^(org.telegram.desktop)$ title:^(Media viever)$"

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
