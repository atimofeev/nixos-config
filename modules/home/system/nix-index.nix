{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom-hm.system.nix-index;
in
{

  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  options.custom-hm.system.nix-index = {
    enable = lib.mkEnableOption "nix-index bundle";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index.enable = false; # show packages for missing command (command-not-found)
      nix-index-database.comma.enable = true;
    };
  };

}
