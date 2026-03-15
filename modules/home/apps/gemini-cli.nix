{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.gemini-cli;

  base-command-prompt = ''
    You are an expert DevOps and CLI assistant. Execute the assigned task strictly using the specified tools.

    Additional user arguments/context: {{args}}
    ---
  '';

  release-template = ''
    ```
    Title: {{project_name}} {{version}}
    Body:
    {{short summary}}

    ## What's Changed
    {{list of commits before current tag/version}}
    ```
  '';
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
          description = "Commit changes";
          prompt = ''
            ${base-command-prompt}
            Task Summary: Commit and push changes to upstram repo
            Tools: Local Shell/Git tools and GitHub MCP
            Task Steps:
            1. **Analyze Changes:** Check the current git status and diff to understand what changes have been made.
            2. **Generate Message:** Draft a commit message strictly following the Conventional Commits specification (e.g., feat(scope):, fix(scope):, chore(scope):, docs(scope):, refactor(scope):). Include a concise description and, if necessary, an extended body.
            3. **Confirm (Optional but recommended):** If your CLI supports user confirmation, present the proposed commit message to the user before proceeding.
            4. **Commit:** Execute the git commit command with the generated message.
            5. **Push:** Push the new commit to the current branch on the remote repository.
          '';
        };
        git_release = {
          description = "Create release";
          prompt = ''
            ${base-command-prompt}
            Task Summary: Create GitHub/GitLab Release
            Tools: Local Shell/Git tools and GitHub MCP
            Task Steps:
            1. **Analyze History:** Fetch the latest git tag. Retrieve all commit messages made since that last tag.
            2. **Create GitHub/GitLab Release:** Use the `gh` or `glab` cli tool to create a new Release on the repository. Use this template for release:
            ${release-template}
          '';
        };
        git_tag = {
          description = "Create tag and release";
          prompt = ''
            ${base-command-prompt}
            Task Summary: Create git SemVer tag
            Tools: Local Shell/Git tools and GitHub MCP
            Task Steps:
            1. **Analyze History:** Fetch the latest git tag. Retrieve all commit messages made since that last tag.
            2. **Determine Semantic Version:** Analyze the commit messages (looking for 'feat', 'fix', 'BREAKING CHANGE', etc.) to determine the next logical version number according to Semantic Versioning (SemVer: MAJOR.MINOR.PATCH).
            3. **Prepare Tag Vesion and Annotation:** Prepare a SemVer tag (e.g. v1.2.3) with annotation: {{list of commits before current tag/version}}.
            4. **Confirm:** Present the proposed tag version and annotation to the user before proceeding.
            5. **Create annotated tag:** Execute git tag command with selected version and annotation.
          '';
        };
        git_tag_and_release = {
          description = "Create tag and release";
          prompt = ''
            ${base-command-prompt}
            Task Summary: Create git SemVer tag and GitHub/GitLab Release
            Tools: Local Shell/Git tools and GitHub MCP
            Task Steps:
            1. **Analyze History:** Fetch the latest git tag. Retrieve all commit messages made since that last tag.
            2. **Determine Semantic Version:** Analyze the commit messages (looking for 'feat', 'fix', 'BREAKING CHANGE', etc.) to determine the next logical version number according to Semantic Versioning (SemVer: MAJOR.MINOR.PATCH).
            3. **Prepare Tag Vesion and Annotation:** Prepare a SemVer tag (e.g. v1.2.3) with annotation: {{list of commits before current tag/version}}.
            4. **Confirm:** Present the proposed tag version and annotation to the user before proceeding.
            5. **Create annotated tag:** Execute git tag command with selected version and annotation.
            6. **Push:** Push annotated tag to upstream repository.
            7. **Create GitHub/GitLab Release:** Use the `gh` or `glab` cli tool to create a new Release on the repository. Use this template for release:
            ${release-template}
          '';
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
