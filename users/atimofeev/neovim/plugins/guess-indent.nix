{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = guess-indent-nvim;
      type = "lua";
      config = "require('guess-indent').setup()";
    }
  ];

}
