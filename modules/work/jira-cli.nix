{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.jira-cli;

in
{

  options.custom.work.jira-cli = {
    enable = lib.mkEnableOption "jira-cli bundle";
    package = lib.mkPackageOption pkgs "jira-cli-go" { };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

  };

}
