{ pkgs, ... }: {

  programs.neovim.plugins = with pkgs.vimPlugins; [{
    plugin = nvim-comment;
    type = "lua";
    config = "require('nvim_comment').setup()";
  }];

}
