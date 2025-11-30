{ pkgs, ... }:
{

  home.packages = with pkgs; [
    adwaita-icon-theme-legacy
  ];

  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.sessionVariables = {
    ADW_DISABLE_PORTAL = "1";
  };

}
