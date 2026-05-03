{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.ai-skills;

  nixomatic-skill = pkgs.fetchFromGitHub {
    owner = "curriedsoftware";
    repo = "nixomatic-skill";
    rev = "f3e901bb0ffac88582ce29e4c43a882f46fe0254";
    hash = "sha256-RqQ+D7V3Yv4gIO7HlvTd5XtgQZARrOqm97lg2t9zlKc=";
  };

  terraform-skill = pkgs.fetchFromGitHub {
    owner = "antonbabenko";
    repo = "terraform-skill";
    rev = "v1.8.0";
    hash = "sha256-DpNrTc51IbY9aYoTxWUlxPTpOZLoHJIquT6cPm9xLB0=";
  };

  merged-skills = pkgs.symlinkJoin {
    name = "merged-ai-skills";
    paths = [
      "${terraform-skill}/skills"
      nixomatic-skill
    ];
  };

in
{

  options.custom-hm.applications.ai-skills = {
    enable = lib.mkEnableOption "ai-skills bundle";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".agents/skills" = {
        source = merged-skills;
        recursive = true;
      };
    };
  };

}
