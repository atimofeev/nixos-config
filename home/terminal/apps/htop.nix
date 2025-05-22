{ pkgs, ... }:
{
  programs.htop = {
    enable = true;
    package = pkgs.htop-vim;
    settings = {
      hide_userland_threads = 1;
      show_cpu_frequency = 1;
      show_cpu_temperature = 1;
      show_program_path = 0;
      highlight_base_name = 1;
    };
  };
}
