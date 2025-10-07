{
  config,
  lib,
  pkgs,
  vars,
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

    sops.secrets."work/env/JIRA_API_TOKEN".owner = vars.username;

    environment = {
      systemPackages = [ cfg.package ];
      shellInit = ''
        export JIRA_API_TOKEN="$(cat ${config.sops.secrets."work/env/JIRA_API_TOKEN".path})"
      '';
    };

  };

}
