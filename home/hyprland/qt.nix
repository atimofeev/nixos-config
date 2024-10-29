{ pkgs, lib, ... }:
let f = lib.mkForce;
in {

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      package = pkgs.adwaita-qt;
      name = f "Adwaita-dark";
    };
  };

}
