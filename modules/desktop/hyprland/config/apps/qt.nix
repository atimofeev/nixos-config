{ pkgs, ... }:
{

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "Adwaita";
      package = pkgs.adwaita-qt;
    };
  };

}
