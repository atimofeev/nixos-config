let
  matchAppId = app-id: {
    _props = {
      inherit app-id;
    };
  };
  matchTitle = title: {
    _props = {
      inherit title;
    };
  };
  matchBoth = app-id: title: {
    _props = {
      inherit app-id title;
    };
  };
in
{
  wayland.windowManager.niri.settings.window-rule = [

    # general
    {
      geometry-corner-radius._args = [
        6.0
        6.0
        6.0
        6.0
      ];
      background-effect.blur = true;
      clip-to-geometry = true;
      draw-border-with-background = false;
      opacity = 1.0;
      open-maximized = true;
    }

    # unfocused translucent
    {
      match._props = {
        is-focused = false;
      };
      opacity = 0.85;
    }

    # non-maximized
    {
      match = map matchAppId [
        "kitty"
        "Slack"
      ];
      open-maximized = false;
    }

    # special workspace
    {
      match = map matchAppId [
        "spotify"
        "spotify_player"
        "org.telegram.desktop"
      ];
      opacity = 1.0;
      open-on-workspace = "special";
    }

    # active / specific titles
    {
      match = [
        { _props.is-active = true; }
      ]
      ++ map matchTitle [
        "Meet"
        "Udemy"
        "YouTube"
      ];
      opacity = 1.0;
    }

    # floating
    {
      match =
        map matchAppId [
          "^pavucontrol$"
          "^pwvucontrol$"
          "^nm-connection-editor$"
          "^blueman-manager$"
          "^.blueman-manager-wrapped$"
          "nvidia-settings"
          "mpv"
          "zoom"
          "Protontricks"
          "xdg-desktop-portal-gtk"
          "steam"
        ]
        ++ [
          (matchBoth "electron" "Open")
          (matchBoth "firefox" "About Mozilla Firefox")
          (matchBoth "firefox" "Library")
          (matchBoth "Slack" "Huddle")
          (matchBoth "Slack" "Canvas")
          (matchBoth "Slack" "^Open File")
        ];
      exclude = [ (matchBoth "steam" "^Steam$") ];
      open-floating = true;
    }

    # picture-in-picture
    {
      match = map matchTitle [
        "^Picture-in-Picture$"
        "^Picture in picture$"
      ];
      opacity = 1.0;
      open-floating = true;
      open-focused = false;
      focus-on-activate = false;
      focus-ring.off = { };
      border.off = { };
      default-column-width.proportion = 0.25;
      default-window-height.proportion = 0.25;
      default-floating-position._props = {
        x = 25;
        y = 25;
        relative-to = "top-right";
      };
    }

  ];
}
