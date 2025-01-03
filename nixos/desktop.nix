{ inputs, pkgs, lib, vars, ... }: {

  environment = {

    sessionVariables = {
      # NOTE: use wayland for electron apps & chromium
      NIXOS_OZONE_WL = "1";
      # NOTE: https://github.com/NixOS/nixpkgs/issues/353990
      GSK_RENDERER = "cairo";
    };

    # systemPackages = with pkgs;
    #   [
    #     switcheroo
    #     gnome-graphs
    #     gnome.gnome-tweaks
    #     gnome.dconf-editor
    #     gnomeExtensions.pop-shell
    #     gnomeExtensions.appindicator
    #     unstable.letterpress
    #     unstable.gnomeExtensions.pip-on-top # update to v8 for compatibility with Gnome 46
    #     unstable.gnomeExtensions.gamemode-shell-extension
    #   ];

  };

  services = {
    dbus.implementation = "broker";

    gvfs.enable = true;

    # displayManager = {
    #   enable = true;
    #   ly = {
    #     enable = true;
    #     settings = {
    #       animation = "none";
    #       asterisk = "*";
    #       # bg = "";
    #       # border_fg = "";
    #       clock = "%a %d %b %Y - %H:%M";
    #       default_input = "password";
    #       # error_bg = "";
    #       # error_fg = "";
    #       load = true;
    #       save = true;
    #     };
    #   };
    # };

    # xserver = {
    #   enable = true;
    #   displayManager = {
    #     lightdm.enable = false;
    #     # gdm.enable = true;
    #   };
    #   # desktopManager.gnome.enable = true;
    #   # xkb = {
    #   #   layout = vars.kb_layouts;
    #   #   options = "grp:win_space_toggle";
    #   # };
    # };

  };

  programs = {

    # nautilus-open-any-terminal = {
    #   enable = true;
    #   terminal = vars.terminal.name;
    # };

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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

}
