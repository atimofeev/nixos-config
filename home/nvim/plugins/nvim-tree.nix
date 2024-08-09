{ pkgs, ... }: {
  programs.neovim = {

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = # lua
          ''
            require('nvim-tree').setup({
              -- update_cwd = true,
              sync_root_with_cwd = true,
              respect_buf_cwd = true,
              update_focused_file = {
                enable = true,
                update_root = true,
              },
              git = { ignore = false },
              filters = {
                custom = { "^\\.git$", "^\\.mypy_cache$", "^\\.terraform$", "^\\.null-ls_" }
              },
              renderer = {
                highlight_git = true,
                icons = {
                  git_placement = "after",
                  glyphs = { git = { unstaged = "•" }, },
                },
              },
            })
          '';
      }
    ];

    extraLuaConfig = # lua
      ''
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
        vim.keymap.set('n','<leader>e','<Cmd>NvimTreeFocus<CR>',{noremap = true, silent = true, desc = "Focus nvim-tree"})
      '';

  };

}
