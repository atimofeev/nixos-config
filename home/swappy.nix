{ pkgs, ... }: {
  home.packages = with pkgs; [ swappy ];

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Downloads
    early_exit=true
  '';
}
