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
      commands = {
        git_commit = {
          prompt = ''
            You are an expert developer assistant. The user wants to commit and push their current work.

            Execute the following steps using your available tools (Local Shell/Git tools and GitHub MCP):
            1. **Analyze Changes:** Check the current git status and diff to understand what changes have been made.
            2. **Generate Message:** Draft a commit message strictly following the Conventional Commits specification (e.g., feat(scope):, fix(scope):, chore(scope):, docs(scope):, refactor(scope):). Include a concise description and, if necessary, an extended body.
            3. **Confirm (Optional but recommended):** If your CLI supports user confirmation, present the proposed commit message to the user before proceeding.
            4. **Commit:** Execute the git commit command with the generated message.
            5. **Push:** Push the new commit to the current branch on the remote repository.
          '';
          description = "Commit changes";
        };
        git_release = {
          prompt = ''
            You are an expert DevOps assistant. The user wants to create a new release for the current repository. 

            Execute the following steps using your available tools (Local Shell/Git tools and GitHub MCP):
            1. **Analyze History:** Fetch the latest git tag. Retrieve all commit messages made since that last tag.
            2. **Determine Semantic Version:** Analyze the commit messages (looking for 'feat', 'fix', 'BREAKING CHANGE', etc.) to determine the next logical version number according to Semantic Versioning (SemVer: MAJOR.MINOR.PATCH).
            3. **Tag and Push:** Create a lightweight or annotated git tag locally with this new version number (e.g., v1.2.3), and push the tag to the remote repository.
            4. **Draft Release Notes:** Compile a short, high-level summary of the changes. Below the summary, create a categorized, bulleted list of all commits made since the previous release.
            5. **Create GitHub Release:** Use the `gh` cli tool to create a new Release on the repository. Use this template for release:
            ```
            Title: {{project_name}} {{version}}
            Body:
            {{short summary}}

            ### What's Changed
            {{list of commits before current tag/version}}
            ```
          '';
          description = "Create tag and release";
        };
      };
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
        mcpServers = {
          github = {
            command = "docker";
            args = [
              "run"
              "-i"
              "--rm"
              "-e"
              "GITHUB_PERSONAL_ACCESS_TOKEN"
              "ghcr.io/github/github-mcp-server"
            ];
            env.GITHUB_PERSONAL_ACCESS_TOKEN = "$GITHUB_MCP_PAT";
          };
          terraform = {
            command = "docker";
            args = [
              "run"
              "-i"
              "--rm"
              "hashicorp/terraform-mcp-server:0.4.0"
            ];
          };
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
