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
      map('n','<Esc>','<Cmd>noh<CR>' ) -- clear highlight

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
