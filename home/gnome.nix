{ lib, vars, ... }: {
  # TODO: tiling
  # https://github.com/material-shell/material-shell
  # https://itsfoss.com/material-shell/

  # https://github.com/forge-ext/forge

  qt = {
    enable = true;
    style.name = "Adwaita-dark";
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true;
    '';
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # Use different keyboard language for each window
      per-window = true;
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "ru" ])
      ];
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "steam.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [ "pip-on-top@rafostar.github.com" ];
    };

    "org/gnome/shell/extensions/pip-on-top" = { stick = true; };

    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/freedesktop/appearance".color-scheme = 1;

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 0;

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 4500;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      toggle-fullscreen = [ "<Super>f" ];
    };

    "org/gnome/shell/keybindings" = {
      # Remove the default hotkeys for opening favorited applications.
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      switch-to-application-10 = [ ];
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

    "org/gnome/TextEditor".keybindings = "vim";

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Super>Return";
        command = vars.terminal.name;
        name = vars.terminal.name;
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Shift><Super>h";
        command = "${vars.terminal.name} -e htop";
        name = "htop";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
      {
        binding = "<Shift><Super>s";
        # show images in kitty
        command = "kitty -o term=xterm-kitty -e spotify_player";
        # command = "${vars.terminal.name} -e spotify_player";
        name = "spotify-player";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" =
      {
        binding = "<Super>e";
        command = "/usr/bin/env nautilus";
        name = "File Manager";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" =
      {
        binding = "<Shift><Super>n";
        command = "${vars.terminal.name} -e nvtop";
        name = "nvtop";
      };
  };

}
