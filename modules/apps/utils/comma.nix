{ inputs, pkgs, ... }: {

  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  programs.nix-index-database.comma.enable = true;

  # environment.systemPackages = [ pkgs.comma ];

}
