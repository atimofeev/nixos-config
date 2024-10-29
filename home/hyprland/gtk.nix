{ pkgs, lib, ... }:
let f = lib.mkForce;
in {

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    theme = {
      package = f pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita-dark";
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
  };

}
