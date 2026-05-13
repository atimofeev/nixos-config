{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.ai-skills;

  antigravity-src = pkgs.fetchFromGitHub {
    owner = "sickn33";
    repo = "antigravity-awesome-skills";
    rev = "v10.9.0";
    hash = "sha256-adHmjcp7tjbw18j1hDQD6Z+96fgdu+57Rw+nxIZURgY=";
  };

  nixomatic-src = pkgs.fetchFromGitHub {
    owner = "curriedsoftware";
    repo = "nixomatic-skill";
    rev = "f3e901bb0ffac88582ce29e4c43a882f46fe0254";
    hash = "sha256-RqQ+D7V3Yv4gIO7HlvTd5XtgQZARrOqm97lg2t9zlKc=";
  };

  terraform-src = pkgs.fetchFromGitHub {
    owner = "antonbabenko";
    repo = "terraform-skill";
    rev = "v1.8.0";
    hash = "sha256-DpNrTc51IbY9aYoTxWUlxPTpOZLoHJIquT6cPm9xLB0=";
  };

  find-skills-src = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "skills";
    rev = "c99a72b371b5b4da865f5afa87c5a686f3a46766";
    hash = "sha256-RYwgUf173N4lGalTta4HkBR7sdZwuzRoAY6M8JsT+RY=";
  };

  hashicorp-agent-skills-src = pkgs.fetchFromGitHub {
    owner = "hashicorp";
    repo = "agent-skills";
    rev = "43ca9b0cde131e20a129c106bc9f6b6f9f1e5c9a";
    hash = "sha256-6lf02w/okO6Y7qJGanhRLZsggWi2EIR14fmZZxJGJ2I=";
  };

  hashicorp-terraform-skills-list = [
    "terraform-test"
    "terraform-search-import"
    "terraform-style-guide"
    "refactor-module"
  ];

  hashicorp-terraform-skill-path = skill:
    if builtins.elem skill [
      "terraform-test"
      "terraform-search-import"
      "terraform-style-guide"
    ]
    then "${hashicorp-agent-skills-src}/terraform/code-generation/skills/${skill}"
    else "${hashicorp-agent-skills-src}/terraform/module-generation/skills/${skill}";

  terramate-agent-skills-src = pkgs.fetchFromGitHub {
    owner = "terramate-io";
    repo = "agent-skills";
    rev = "fb28900fe71a92cc29428e2f3a08f588ecc6068b";
    hash = "sha256-YBA1kmV2XJF10jGwn6dfBGCzXHqGpFMLwlUpyTLvIhM=";
  };

  terramate-skills-list = [
    "terraform-best-practices"
    "terramate-best-practices"
  ];

in
{
  options.custom-hm.applications.ai-skills = {
    enable = lib.mkEnableOption "ai-skills bundle";

    nixomatic-skill.enable = lib.mkEnableOption "nixomatic skill";
    terraform-skill.enable = lib.mkEnableOption "terraform skill";
    find-skills.enable = lib.mkEnableOption "find-skills (vercel-labs)";
    hashicorp-terraform-skills.enable = lib.mkEnableOption "hashicorp terraform skills bundle";
    terramate-skills.enable = lib.mkEnableOption "terramate skills bundle";

    antigravity-awesome-skills = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "code-review-checklist"
        "debugging-strategies"
      ];
      description = "List of specific auto-resolving skills to source from the antigravity repo.";
    };
  };

  config = lib.mkIf cfg.enable {
    custom-hm.applications.ai-skills = {
      nixomatic-skill.enable = lib.mkDefault true;
      terraform-skill.enable = lib.mkDefault true;
      find-skills.enable = lib.mkDefault true;
      hashicorp-terraform-skills.enable = lib.mkDefault true;
      terramate-skills.enable = lib.mkDefault true;
    };

    home.file = lib.mkMerge [
      (lib.mkIf cfg.nixomatic-skill.enable {
        ".agents/skills/nixomatic".source = nixomatic-src;
      })

      (lib.mkIf cfg.terraform-skill.enable {
        ".agents/skills/terraform".source = "${terraform-src}/skills";
      })

      (lib.mkIf cfg.find-skills.enable {
        ".agents/skills/find-skills".source = "${find-skills-src}/skills/find-skills";
      })

      (lib.mkIf cfg.hashicorp-terraform-skills.enable (
        builtins.listToAttrs (
          map (skill: {
            name = ".agents/skills/${skill}";
            value.source = hashicorp-terraform-skill-path skill;
          }) hashicorp-terraform-skills-list
        )
      ))

      (lib.mkIf cfg.terramate-skills.enable (
        builtins.listToAttrs (
          map (skill: {
            name = ".agents/skills/${skill}";
            value.source = "${terramate-agent-skills-src}/skills/${skill}";
          }) terramate-skills-list
        )
      ))

      (builtins.listToAttrs (
        map (skill: {
          name = ".agents/skills/${skill}";
          value = {
            source = "${antigravity-src}/skills/${skill}";
          };
        }) cfg.antigravity-awesome-skills
      ))
    ];
  };
}
