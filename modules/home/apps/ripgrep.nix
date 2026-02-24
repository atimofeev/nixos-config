{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.ripgrep;
in
{

  options.custom-hm.applications.ripgrep = {
    enable = lib.mkEnableOption "ripgrep bundle";
    package = lib.mkPackageOption pkgs "ripgrep" { };
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      inherit (cfg) package;
      arguments = [
        # "--color=always" # conflict with telescope.nvim
        "--smart-case"
        "--no-line-number"
        "--hidden"
        "--glob=!.git/*"
        "--max-columns=150"
        "--max-columns-preview"
      ];
    };
  };

}
