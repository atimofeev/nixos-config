{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [{
    plugin = mini-nvim;
    type = "lua";
    config = # lua
      ''
        require("mini.surround").setup({
          mappings = { -- fix KB collision with leap.nvim
            add = "gza", -- Add surrounding in Normal and Visual modes
            delete = "gzd", -- Delete surrounding
            find = "gzf", -- Find surrounding (to the right)
            find_left = "gzF", -- Find surrounding (to the left)
            highlight = "gzh", -- Highlight surrounding
            replace = "gzr", -- Replace surrounding
            update_n_lines = "gzn", -- Update `n_lines`

            suffix_last = "N", -- Suffix to search with "prev" method
            suffix_next = "n", -- Suffix to search with "next" method
          },

          -- Number of lines within which surrounding is searched
          n_lines = 45,
        })
      '';
  }];
}
