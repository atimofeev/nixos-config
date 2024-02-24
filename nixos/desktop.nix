{ inputs, pkgs, vars, ... }: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = vars.kb_layouts;
    xkb.options = "grp:win_space_toggle";

    displayManager = {
      gdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = vars.username;
    };

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

  services.xremap = {
    # withHypr = true;
    withGnome = true;
    userName = vars.username;
    config = {
      modmap = [{
        name = "main remaps";
        remap = { capslock = "shift_l"; };
      }];
    };
  };

}
