{ pkgs, ... }: {
  programs.neovim = {

    plugins = with pkgs.vimPlugins; [{
      plugin = harpoon;
      type = "lua";
      config = "require('harpoon').setup()";
    }];

    extraLuaConfig = # lua
      ''
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
        vim.keymap.set('n','<leader>hx','<Cmd>lua require("harpoon.mark").add_file()<CR>',{noremap = true, silent = true, desc = "Harpoon Mark"})
        vim.keymap.set('n','<leader>hn','<Cmd>lua require("harpoon.ui").nav_next()<CR>',{noremap = true, silent = true, desc = "Harpoon Next"})
        vim.keymap.set('n','<leader>hp','<Cmd>lua require("harpoon.ui").nav_prev()<CR>',{noremap = true, silent = true, desc = "Harpoon Previous"})
        vim.keymap.set('n','<leader>hl','<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',{noremap = true, silent = true, desc = "Harpoon List"})
      '';

  };
}
