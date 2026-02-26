{

  programs.niri.settings.window-rules = [

    # general
    {
      geometry-corner-radius = {
        top-left = 6.0;
        top-right = 6.0;
        bottom-left = 6.0;
        bottom-right = 6.0;
      };
      clip-to-geometry = true;
      draw-border-with-background = false;
      opacity = 1.0;
      open-maximized = true;
    }

    # unfocused translucent
    {
      matches = [
        { is-focused = false; }
      ];
      opacity = 0.85;
    }

    # non-maximized
    {
      matches = [
        { app-id = "kitty"; }
        { app-id = "Slack"; }
      ];
      open-maximized = false;
    }

    # special workspace
    {
      matches = [
        { app-id = "spotify"; }
        { app-id = "spotify_player"; }
        { app-id = "org.telegram.desktop"; }
      ];
      opacity = 1.0;
      open-on-workspace = "special";
    }

    {
      matches = [
        { is-active = true; }
        { title = "Meet"; }
        { title = "Udemy"; }
        { title = "YouTube"; }
      ];
      opacity = 1.0;
    }

    # floating
    {
      matches = [
        { app-id = "^pavucontrol$"; }
        { app-id = "^pwvucontrol$"; }
        { app-id = "^nm-connection-editor$"; }
        { app-id = "^blueman-manager$"; }
        { app-id = "^.blueman-manager-wrapped$"; }
        { app-id = "nvidia-settings"; }
        { app-id = "mpv"; }
        { app-id = "zoom"; }
        { app-id = "Protontricks"; }
        { app-id = "xdg-desktop-portal-gtk"; }
        { app-id = "steam"; }
        {
          app-id = "electron";
          title = "Open";
        }
        {
          app-id = "firefox";
          title = "About Mozilla Firefox";
        }
        {
          app-id = "firefox";
          title = "Library";
        }
        {
          app-id = "Slack";
          title = "Huddle";
        }
        {
          app-id = "Slack";
          title = "Canvas";
        }
        {
          app-id = "Slack";
          title = "^Open File";
        }
      ];
      excludes = [
        {
          app-id = "steam";
          title = "^Steam$";
        }
      ];
      open-floating = true;
    }

    # picture-in-picture
    {
      matches = [
        { title = "^Picture-in-Picture$"; }
        { title = "^Picture in picture$"; }
      ];
      opacity = 1.0;
      open-floating = true;
      open-focused = false;
      default-column-width.proportion = 0.25;
      default-window-height.proportion = 0.25;
      default-floating-position = {
        x = 25;
        y = 25;
        relative-to = "top-right";
      };
    }

  ];

}
