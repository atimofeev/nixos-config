{ inputs, ... }:
{

  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  programs = {
    nix-index.enable = false; # show packages for missing command (command-not-found)
    nix-index-database.comma.enable = true;
  };

}
