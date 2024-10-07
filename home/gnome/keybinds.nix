{ pkgs, vars, ... }: {
  dconf.settings = {
    "org/gnome/TextEditor".keybindings = "vim";

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

    "org/gnome/settings-daemon/plugins/media-keys" = {
      next = [ "<Shift><Control>n" ];
      previous = [ "<Shift><Control>p" ];
      play = [ "<Shift><Control>space" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Super>Return";
        command = vars.terminal.name;
        inherit (vars.terminal) name;
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Shift><Super>h";
        command = "${vars.terminal.name} -e htop";
        name = "htop";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
      let
        # show images in kitty
        spotifyPlayerCMD = if vars.terminal.name == "kitty" then
          "kitty -o term=xterm-kitty -e spotify_player"
        else
          "${vars.terminal.name} -e spotify_player";
      in {
        binding = "<Shift><Super>s";
        command = spotifyPlayerCMD;
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

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" =
      {
        binding = "<Super>Print";
        command =
          "${pkgs.bash}/bin/bash -c '${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.swappy}/bin/swappy -f -'";
        name = "Edit clipboard image";
      };

  };
}
