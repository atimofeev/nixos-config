{ pkgs, lib, ... }:
let f = lib.mkForce;
in {

  gtk = {
    enable = true;
    theme = {
      package = f pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
  };

}
