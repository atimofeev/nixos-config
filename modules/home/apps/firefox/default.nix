{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.firefox;
in
{

  imports = [
    ./betterfox.nix
    ./extensions.nix
    ./policies.nix
    ./search.nix
    ./settings.nix
    ./user-content.nix
  ];

  options.custom-hm.applications.firefox = {
    enable = lib.mkEnableOption "firefox bundle";
    package = lib.mkPackageOption pkgs "firefox" { };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      inherit (cfg) package;
      profiles.default.isDefault = true;
    };
  };

}
