{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.gemini-cli;
in
{

  options.custom-hm.applications.gemini-cli = {
    enable = lib.mkEnableOption "gemini-cli bundle";
    package = lib.mkPackageOption pkgs "gemini-cli" { };
  };

  config = lib.mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;
      inherit (cfg) package;
      settings = {
        billing.overageStrategy = "never";
        general = {
          enableAutoUpdate = true;
          enableAutoUpdateNotification = true;
          enablePromptCompletion = true;
          maxAttempts = 30;
          preferredEditor = "neovim";
          previewFeatures = true;
          sessionRetention = {
            enabled = true;
            maxAge = "60d";
          };
          vimMode = true;
        };
        privacy.usageStatisticsEnabled = false;
        security.auth.selectedType = "oauth-personal";
        theme = "Atom One";
        tools = {
          allowed = [
            "arp"
            "echo"
            "grep"
            "head"
            "jq"
            "ls"
            "nc"
            "ping"
            "sleep"
            "tail"
            "yq"
            # NOTE: terraform MCP
            "search_providers"
            "get_provider_details"
          ];
          sandbox = "docker";
          shell.showColor = true;
        };
        ui.theme = "GitHub";
      };

    };

  };

}
