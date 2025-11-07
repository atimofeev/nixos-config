{ pkgs, ... }:
{

  home.packages = with pkgs; [
    adwaita-icon-theme-legacy
  ];

  gtk = {
    enable = true;

    # NOTE: replace with gtk.colorScheme = "dark";
    # on 25.11
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-interface-color-scheme = 2;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.sessionVariables = {
    ADW_DISABLE_PORTAL = "1";
  };

}
