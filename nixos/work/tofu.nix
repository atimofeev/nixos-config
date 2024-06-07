{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = [ pkgs.terraform pkgs-unstable.opentofu ];
}
