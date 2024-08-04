{ pkgs, ... }: {
  programs.neovim = {

    plugins = with pkgs.vimPlugins; [{
      plugin = toggleterm-nvim;
      type = "lua";
      config = # lua
        ''
          require("toggleterm").setup({
            direction = "float",
            float_opts = {border = "curved"},
            open_mapping = [[<C-\>]],
            size = function(term)
              if term.direction == "horizontal" then
                return 20
              elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
              end
            end
          })
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

        map('t','<Esc>','<C-\\><C-N>') -- escape terminal mode
        map('n','<leader>v','<Cmd>ToggleTerm direction=vertical<CR>') -- toggleterm vertical
        map('n','<leader>s','<Cmd>ToggleTerm direction=horizontal<CR>') -- toggleterm horizontal
        map('n','<leader>B','<Cmd>enew | setlocal nonumber norelativenumber | term<CR>i') -- toggleterm buffer 
        map('n','<C-w>S','<Cmd>20new | setlocal nonumber norelativenumber | term<CR>i') -- term split
        map('n','<C-w>V','<Cmd>80vnew | setlocal nonumber norelativenumber | term<CR>i') -- term split
        map('n','<leader>tt','<Cmd>ToggleTerm direction=tab<CR>') -- toggleterm tab
        -- map('n','<leader>fT','<Cmd>Telescope toggleterm<CR>') -- Telescope integration
        map('t','<C-h>','<Cmd>wincmd h<CR>')
        map('t','<C-j>','<Cmd>wincmd j<CR>')
        map('t','<C-k>','<Cmd>wincmd k<CR>')
        -- map('t','<C-l>',':wincmd l<CR>') -- interference with <C-l> for `clear`
      '';
  };
}
