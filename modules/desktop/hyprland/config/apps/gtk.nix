{ pkgs, ... }:
{

  home = {

    packages = with pkgs; [
      adwaita-icon-theme-legacy
    ];

    sessionVariables = {
      # NOTE: redundant? we're using the gtk portal
      ADW_DISABLE_PORTAL = "1";
    };

  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

}
