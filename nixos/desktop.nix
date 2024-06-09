{ inputs, pkgs, pkgs-unstable, vars, ... }: {

  environment.systemPackages = (with pkgs; [
    switcheroo
    gnome-graphs
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnomeExtensions.appindicator
  ]) ++ (with pkgs-unstable; [
    letterpress
    gnomeExtensions.pip-on-top # update to v8 for compatibility with Gnome 46
  ]);

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    xkb.layout = vars.kb_layouts;
    xkb.options = "grp:win_space_toggle";

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;
  };
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = vars.username;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      #xwayland.enable = true;
    };
  };

}
