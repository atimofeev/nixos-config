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
      defaultModel = "gemini-3-pro-preview";
      settings = {
        general = {
          enablePromptCompletion = true;
          preferredEditor = "nvim";
          previewFeatures = true;
          vimMode = true;
        };
        privacy.usageStatisticsEnabled = false;
        security.auth.selectedType = "oauth-personal";
        theme = "Atom One";
        tools.allowed = [
          "echo"
          "grep"
          "ls"
          # NOTE: terraform MCP
          "search_providers"
          "get_provider_details"
        ];
        ui.theme = "GitHub";
      };

    };

  };

}
