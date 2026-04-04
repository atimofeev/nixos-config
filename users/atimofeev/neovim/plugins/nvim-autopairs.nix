{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-autopairs;
      type = "lua";
      config = "require('nvim-autopairs').setup()";
    }
  ];

}
