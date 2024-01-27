{ inputs, pkgs, vars, ... }: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      # Enable automatic login for the user.
      autoLogin.enable = true;
      autoLogin.user = vars.username;
    };
    # Configure keymap in X11
    xkb.layout = vars.kb_layouts;
    xkb.options = "grp:win_space_toggle";

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    #xwayland.enable = true;
  };

}
