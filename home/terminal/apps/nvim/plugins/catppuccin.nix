{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [{
    plugin = catppuccin-nvim;
    type = "lua";
    config = # lua
      ''
        require("catppuccin").setup({
          flavour = "macchiato",
          })
        vim.opt.background = dark
        vim.cmd.colorscheme "catppuccin"
      '';
  }];
}
