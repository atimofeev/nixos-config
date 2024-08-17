_: {
  programs.neovim.extraLuaConfig = # lua
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

      -- main
      map('n',';',':',{silent = false}) -- cmd mode with ;
      map('n',':',';',{silent = false}) -- next symbol match with :
      map('x','p','P') -- paste without yank
      map('x','P','p') -- paste and yank
      map({'n','v'},'j','gj') -- go through wrapped lines
      map({'n','v'},'k','gk')
      map({'n','v'},'<S-g>','<S-g>10<C-e>') -- scrolloff 10 lines after going to EOF
      map('n','<Esc>','<Cmd>noh<CR>' ) -- clear highlight

      -- buffers & tabs
      map('n','<leader>b','<Cmd>enew<CR>',{desc = "New buffer"})
      map('n','<leader>x','<Cmd>confirm bdelete<CR>',{desc = "Close buffer"})
      map('n','<Tab>','<Cmd>bnext<CR>',{desc = "Next buffer"})
      map('n','<S-Tab>','<Cmd>bprev<CR>',{desc = "Prev buffer"})
      map('n','<leader>t','<Cmd>tabnew<CR>',{desc = "New tab"})

      -- terminal
      map('t','jk','<C-\\><C-n>') -- escape terminal mode
      map('n','<leader>B','<Cmd>enew | setlocal nonumber norelativenumber | term<CR>i',{desc = "Term buffer"})
      map('n','<leader>T','<Cmd>tabnew | setlocal nonumber norelativenumber | term<CR>i',{desc = "Term tab"})

      -- navigate windows
      map('n','<C-h>','<C-w>h')
      map('n','<C-j>','<C-w>j')
      map('n','<C-k>','<C-w>k')
      map('n','<C-l>','<C-w>l')

      -- resize windows
      map('n','<C-Up>','<Cmd>resize -2<CR>')
      map('n','<C-Down>','<Cmd>resize +2<CR>')
      map('n','<C-Left>','<Cmd>vertical resize -2<CR>')
      map('n','<C-Right>','<Cmd>vertical resize +2<CR>')
    '';
}
