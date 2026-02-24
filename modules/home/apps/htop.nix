{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.htop;
in
{

  options.custom-hm.applications.htop = {
    enable = lib.mkEnableOption "htop bundle";
    package = lib.mkPackageOption pkgs "htop" { };
  };

  config = lib.mkIf cfg.enable {
    programs.htop = {
      enable = true;
      inherit (cfg) package;
      settings = {
        hide_userland_threads = 1;
        show_cpu_frequency = 1;
        show_cpu_temperature = 1;
        show_program_path = 0;
        highlight_base_name = 1;
      };
    };
  };

}
