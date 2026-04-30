{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.ai-skills;

  terraform-skill = pkgs.fetchFromGitHub {
    owner = "antonbabenko";
    repo = "terraform-skill";
    rev = "2057f15bf57e22baa7e96bc16bed3f6914f1ae2f";
    hash = "sha256-Uq9m1FDnhQaSiPhhWmNBeNOAxzVd1Ejtrren+DlR+z8=";
  };
in
{

  options.custom-hm.applications.ai-skills = {
    enable = lib.mkEnableOption "ai-skills bundle";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".agents/skills/terraform-skill" = {
        source = "${terraform-skill}/skills/terraform-skill";
        recursive = true;
      };
    };
  };

}
