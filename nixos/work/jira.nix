{ pkgs, config, vars, ... }: {

  sops.secrets."work/env/JIRA_API_TOKEN".owner = vars.username;

  environment = {
    systemPackages = with pkgs; [ jira-cli-go ];
    shellInit = ''
      export JIRA_API_TOKEN="$(cat ${
        config.sops.secrets."work/env/JIRA_API_TOKEN".path
      })"
    '';
  };

}
