{ pkgs, ... }: {
  programs.neovim = {
    # TODO: telescope integration
    # plugins.telescope.enabledExtensions = mkIf cfg.enableTelescope [ "projects" ];
    plugins = with pkgs.vimPlugins; [{
      plugin = project-nvim;
      type = "lua";
      config = # lua
        ''
          require("project_nvim").setup({
            patterns = {".git"},
            ignore_lsp = {"null-ls", "dockerls"},
            show_hidden = true,
          })
        '';
    }];

    extraLuaConfig = # lua
      ''
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
        vim.keymap.set('n','<leader>fp','<Cmd>Telescope projects<CR>',{noremap = true, silent = true})
        vim.keymap.set('n','<leader><leader>','<Cmd>Telescope projects<CR>',{noremap = true, silent = true})
      '';
  };
}
