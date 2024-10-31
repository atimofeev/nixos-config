{ vars, ... }: {
  wayland.windowManager.hyprland.settings = {

    windowrule = [
      "float, org.kde.polkit-kde-authentication-agent-1"
      "float, nm-connection-editor|blueman-manager"
      "float, nwg-look|qt5ct|mpv"
      "float, onedriver|onedriver-launcher"
      "float, eog"
      "float, zoom"
      "float, rofi"
      "float, gnome-system-monitor"
      "float, yad"
      "center, ^(pavucontrol) "

      "float, pavucontrol"
      "float, nvidia-settings"
    ];

    windowrulev2 = [
      "float, class:steam, title:^(Steam Settings|Sign in to Steam)$"
      "float, class:firefox, title:^(About Mozilla Firefox)$"

      "opacity 0.9 0.6, class:^([Rr]ofi)$"
      # "opacity 0.9 0.7, class:^(firefox)$"
      # "opacity 0.9 0.8, class:^([Tt]hunar)$"
      # "opacity 0.8 0.6, class:^(pcmanfm-qt)$"
      # "opacity 0.9 0.7, class:^(gedit)$"
      # "opacity 0.95 0.8, class:^(${vars.terminal.name})$"
      # "opacity 0.9 0.7, class:^(mousepad)$"
      # "opacity 0.9 0.7, class:^(yad)$"

      # Picture-in-a-Picture (PIP) rules: Oddly, some need re-duplication.  This is because the window for
      # PIP changes after on first launch, and will not inherit the rules...
      "opacity 1 1, title:^(Firefox|Picture-in-Picture)$"
      "pin, title:^(Firefox|Picture-in-Picture)$"
      "float, title:^(Firefox|Picture-in-Picture)$"
      "size 25% 25%, title:^(Firefox|Picture-in-Picture)$"
      "move 72% 7%, title:^(Firefox|Picture-in-Picture)$"
    ];
  };
}
