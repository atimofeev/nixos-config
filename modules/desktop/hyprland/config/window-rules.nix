{
  wayland.windowManager.hyprland.settings = {

    windowrulev2 = [
      "float, class:^(pavucontrol|.*pwvucontrol.*)$"
      "float, class:^(nm-connection-editor|blueman-manager|.blueman-manager-wrapped)$"
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
      "focusonactivate 0, class:org.telegram.desktop"

      "tag +polkit-agent, class:polkit-gnome-authentication-agent-1"
      "stayfocused, tag:polkit-agent"
      "dimaround, tag:polkit-agent"
      "noanim, tag:polkit-agent"

      "float, class:firefox, title:^(About Mozilla Firefox|Library)$"
      "float, class:firefox, title:^()$" # Page Info — .* initial title

      "opacity 1.0 override, title:^(.*YouTube.*|Meet –.*)$"

      "tag +pip, title:^(Picture-in-Picture|Picture in picture)$"
      "focusonactivate 0, tag:pip"
      "noinitialfocus, tag:pip"
      "opacity 1.0 override, tag:pip"
      "float, tag:pip"
      "pin, tag:pip"
      "size 25% 25%, tag:pip"
      "move 72% 7%, tag:pip"
    ];

  };
}
