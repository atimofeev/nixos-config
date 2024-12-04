{ pkgs, lib, ... }:
let f = lib.mkForce;
in {

  gtk = {
    enable = true;
    theme = {
      package = f pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

}
