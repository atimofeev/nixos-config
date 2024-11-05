{ inputs, pkgs, vars, ... }: {

  environment.systemPackages = with pkgs; [
    switcheroo
    gnome-graphs
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnomeExtensions.pop-shell
    gnomeExtensions.appindicator
    unstable.letterpress
    unstable.gnomeExtensions.pip-on-top # update to v8 for compatibility with Gnome 46
    unstable.gnomeExtensions.gamemode-shell-extension
  ];

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

    nautilus-open-any-terminal = {
      enable = true;
      terminal = vars.terminal.name;
    };

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      #xwayland.enable = true;
    };

  };

  xdg.portal = {
    enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
    # extraPortals = [
    #   inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    #   pkgs.xdg-desktop-portal-gtk
    # ];
  };

}
