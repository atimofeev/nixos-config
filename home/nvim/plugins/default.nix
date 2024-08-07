{ pkgs, ... }: {
  imports = [
    ./catppuccin.nix
    ./kitty-scrollback.nix
    ./lualine.nix
    ./mini-surround.nix
    # ./nvim-tree.nix
    ./oil.nix
    # ./project.nix
    # ./telescope.nix
    # ./toggleterm.nix
    # ./treesitter.nix
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-move
    {
      plugin = better-escape-nvim;
      type = "lua";
      config = ''
        require("better_escape").setup()
      '';
    }
    {
      plugin = nvim-comment;
      type = "lua";
      config = ''
        require('nvim_comment').setup()
      '';
    }
    {
      plugin = nvim-autopairs;
      type = "lua";
      config = ''
        require("nvim-autopairs").setup()
      '';
    }
  ];
}
