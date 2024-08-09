{ pkgs, ... }: {
  programs.neovim = {

    plugins = with pkgs.vimPlugins; [{
      plugin = which-key-nvim;
      type = "lua";
      config = # lua
        ''
          require('which-key').setup()
        '';
    }];

  };
}
