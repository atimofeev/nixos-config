{ pkgs, ... }: {
  programs.neovim = {

    plugins = with pkgs.vimPlugins; [{
      plugin = telescope-nvim;
      type = "lua";
      config = # lua
        ''
          -- Borderless telescope views
          local colors = require("catppuccin.palettes").get_palette()
          local TelescopeColor = {
            TelescopeMatching = { fg = colors.flamingo },
            TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
            TelescopePromptPrefix = { bg = colors.surface0 },
            TelescopePromptNormal = { bg = colors.surface0 },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopePreviewNormal = { bg = colors.mantle },
            TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
            TelescopeResultsTitle = { fg = colors.mantle },
            TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
          }

          for hl, col in pairs(TelescopeColor) do
            vim.api.nvim_set_hl(0, hl, col)
          end

          local telescope = require('telescope')
          telescope.setup{
            defaults = {
              vimgrep_arguments = {
                "rg",
                "--hidden",
                "--follow",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--sortr=modified",
              },
              prompt_prefix = "   ",
              selection_caret = "  ",
              entry_prefix = "  ",
              initial_mode = "insert",
              selection_strategy = "reset",
              sorting_strategy = "ascending",
              layout_strategy = "flex",
              layout_config = {
                horizontal = {
                  prompt_position = "top",
                },
                vertical = {
                  prompt_position = "top",
                  mirror = true;
                },
                width = 0.90,
              },
              file_sorter = require("telescope.sorters").get_fuzzy_file,
              file_ignore_patterns = { "node_modules/", "%.git/", "%.mypy_cache/", "%.terraform/" },
              generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
              path_display = { "truncate" },
              winblend = 0,
              border = {},
              borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
              color_devicons = true,
              set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
              file_previewer = require("telescope.previewers").vim_buffer_cat.new,
              grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
              qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
              -- Developer configurations: Not meant for general override
              buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
              mappings = {
                n = {
                  ["q"] = require("telescope.actions").close,
                  ["<esc>"] = require("telescope.actions").close,
                  ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
                  ["<C-j>"] = require("telescope.actions").preview_scrolling_down,
                  ["<C-k>"] = require("telescope.actions").preview_scrolling_up,
                  ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
                },
                i = {
                  ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
                  ["<C-j>"] = require("telescope.actions").preview_scrolling_down,
                  ["<C-k>"] = require("telescope.actions").preview_scrolling_up,
                  ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
                },
              },
            },
            extensions_list = { "themes", "terms" },
            pickers = { find_files = {
                hidden = true,
                find_command = {"rg", "--files", "--sortr=modified"};
              },
            },
          }
        '';
    }];

    extraLuaConfig = # lua
      ''
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '

        function map(mode, lhs, rhs, opts)
          local options = {noremap = true, silent = true}
          if opts then
            options = vim.tbl_extend("force", options, opts)
          end
          vim.keymap.set(mode, lhs, rhs, options)
        end

        map('n','<leader>ff','<Cmd>Telescope find_files<CR>')
        map('n','<leader>fa','<Cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>')
        map('n','<leader>fw','<Cmd>Telescope live_grep<CR>')
        map('n','<leader>fb','<Cmd>Telescope buffers<CR>')
        map('n','<leader>fh','<Cmd>Telescope help_tags<CR>')
        map('n','<leader>fr','<Cmd>Telescope oldfiles<CR>')
        map('n','<leader>fz','<Cmd>Telescope current_buffer_fuzzy_find<CR>')
        map('n','<leader>fgc','<Cmd>Telescope git_commits<CR>')
        map('n','<leader>fgC','<Cmd>Telescope git_bcommits<CR>')
        map('n','<leader>fgs','<Cmd>Telescope git_status<CR>')
        map('n','<leader>fgS','<Cmd>Telescope git_stash<CR>')
        map('n','<leader>fgb','<Cmd>Telescope git_branches<CR>')
        map('n','<leader>fk','<Cmd>Telescope keymaps<CR>')
        -- {
        --   mode = "n";
        --   key = "<leader>ft";
        --   action = "<cmd> TodoTelescope <cr>";
        --   options.desc = "Find TODOs";
        -- }
      '';
  };
}
