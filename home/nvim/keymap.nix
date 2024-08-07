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
      map('x','p','P') -- paste without yank
      map('x','P','p') -- paste and yank
      map({'n','v'},'j','gj') -- go through wrapped lines
      map({'n','v'},'k','gk')
      map({'n','v'},'<S-g>','<S-g>10<C-e>') -- scrolloff 10 lines after going to EOF
      map('n','<Esc>','<Cmd>noh<CR>' ) -- clear highlight

      -- buffers & tabs
      map('n','<leader>b','<Cmd>enew<CR>' ) -- new buffer
      map('n','<leader>x','<Cmd>confirm bdelete<CR>' ) -- close buffer
      map('n','<Tab>','<Cmd>bnext<CR>' ) -- next buffer
      map('n','<S-Tab>','<Cmd>bprev<CR>' ) -- previous buffer
      map('n','<leader>t','<Cmd>tabnew<CR>' ) -- new tab

      -- terminal
      map('t','jk','<C-\\><C-n>' ) -- escape terminal mode
      map('n','<leader>B','<Cmd>enew | setlocal nonumber norelativenumber | term<CR>i') -- term new buffer
      map('n','<leader>T','<Cmd>tabnew | setlocal nonumber norelativenumber | term<CR>i') -- term new tab

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
