{ pkgs, ... }:
{
  programs.neovim = {

    plugins = with pkgs.vimPlugins; [
      rainbow-delimiters-nvim
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = # lua
          ''
            require("nvim-treesitter.configs").setup()
          '';
      }
    ];

  };
}
