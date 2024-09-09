{ pkgs, ... }: {

  programs.neovim.plugins = with pkgs.vimPlugins; [{
    plugin = mini-nvim;
    type = "lua";
    config = "require('mini.move').setup()";
  }];

}
