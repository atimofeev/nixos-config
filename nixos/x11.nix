{ ... }: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      # Enable automatic login for the user.
      autoLogin.enable = true;
      # TODO: username: use global variable
      autoLogin.user = "atimofeev";
    };
    # Configure keymap in X11
    # TODO: kb_layouts: use global variable
    xkb.layout = "us,ru";
    xkb.options = "grp:win_space_toggle";

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };
}
