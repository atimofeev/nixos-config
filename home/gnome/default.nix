{ lib, vars, ... }: {

  imports =
    [ ./dark-mode.nix ./extensions.nix ./input.nix ./keybinds.nix ./power.nix ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "steam.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${../../assets/dark-shore.png}";
      picture-uri-dark = "file://${../../assets/dark-shore.png}";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${../../assets/dark-shore.png}";
      picture-uri-dark = "file://${../../assets/dark-shore.png}";
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [ "scale-monitor-framebuffer" ]; # hidpi
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true;
      focus-mode = "sloppy";
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      sort-directories-first = true;
      view-type = "list";
    };
  };
}
