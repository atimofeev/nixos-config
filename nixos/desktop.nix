{ inputs, pkgs, lib, vars, ... }: {

  environment = {

    # use wayland for electron apps & chromium
    # sessionVariables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs;
      [
        # switcheroo
        # gnome-graphs
        # gnome.gnome-tweaks
        # gnome.dconf-editor
        # gnomeExtensions.pop-shell
        # gnomeExtensions.appindicator
        # unstable.letterpress
        # unstable.gnomeExtensions.pip-on-top # update to v8 for compatibility with Gnome 46
        # unstable.gnomeExtensions.gamemode-shell-extension
      ];

  };

  services = {
    gvfs.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;
      xkb = {
        layout = vars.kb_layouts;
        options = "grp:win_space_toggle";
      };
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
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

  };

  xdg.portal = {
    enable = true;
    configPackages = lib.mkDefault
      [ inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = [ "hyprland" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
  };

  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };

}
