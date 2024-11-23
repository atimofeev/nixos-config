{ pkgs, ... }: {

  programs.neovim.plugins = with pkgs.vimPlugins; [{
    plugin = better-escape-nvim;
    type = "lua";
    config = "require('better_escape').setup({mapping = { 'jk', 'ол' },})";
  }];

}
