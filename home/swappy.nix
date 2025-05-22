{ pkgs, ... }:
{

  # TODO: create home-manager module
  # example: https://github.com/nix-community/home-manager/pull/3904
  home.packages = with pkgs; [ swappy ];

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Downloads
    early_exit=true
  '';
}
