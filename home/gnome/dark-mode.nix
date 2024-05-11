{ lib, ... }: {
  qt = {
    enable = true;
    style.name = "Adwaita-dark";
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true;
    '';
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/freedesktop/appearance".color-scheme = 1;

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 4500;
    };
  };
}
