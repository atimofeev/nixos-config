{ pkgs, lib, ... }:
let f = lib.mkForce;
in {

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      # package = pkgs.adwaita-qt;
      name = f "adwaita-dark";
    };
  };

}
