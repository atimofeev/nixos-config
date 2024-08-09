{ pkgs, ... }:
let
  gx-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "gx.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "chrishrb";
      repo = name;
      rev = "d921f21f200113fd3201194aa9dddb033e83768a";
      hash = "sha256-2Oek8PncbzFhyA7u8p/4cqzroVA6eJOr1+AUaZgHZMY=";
    };
  };
in {
  programs.neovim = {

    plugins = (with pkgs.vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      {
        plugin = oil-nvim;
        type = "lua";
        config = # lua
          ''
            require("oil").setup({
              default_file_explorer = true,
              delete_to_trash = true,
              skip_confirm_for_simple_edits = true,
              view_options = {
                show_hidden = true,
                natural_order = true,
                is_always_hidden = function(name, _)
                      return name == '..' or name == '.git'
                    end,
              },
              win_options = { wrap = true };
            })
          '';
      }
    ]) ++ [{
      # TODO: setup https://github.com/chrishrb/gx.nvim
      plugin = gx-nvim;
      type = "lua";
      config = "require('gx').setup()";
    }];

    extraLuaConfig = # lua
      ''
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
        vim.keymap.set('n','<leader>o','<Cmd>Oil<CR>',{noremap = true, silent = true})
        vim.keymap.set({'n','x'},'gx','<Cmd>Browse<CR>',{noremap = true, silent = true}) -- fix gx(netrw) disabled by Oil
      '';

  };
}
