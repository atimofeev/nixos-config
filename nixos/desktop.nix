{ inputs, pkgs, pkgs-unstable, vars, ... }: {

  environment.systemPackages = (with pkgs; [
    switcheroo
    gnome-graphs
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnomeExtensions.pop-shell
    gnomeExtensions.appindicator
  ]) ++ (with pkgs-unstable; [
    letterpress
    gnomeExtensions.pip-on-top # update to v8 for compatibility with Gnome 46
  ]);

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    xkb = {
      layout = vars.kb_layouts;
      options = "grp:win_space_toggle";
    };
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      #xwayland.enable = true;
    };
    nautilus-open-any-terminal = {
      enable = true;
      terminal = vars.terminal.name;
    };
  };

}
