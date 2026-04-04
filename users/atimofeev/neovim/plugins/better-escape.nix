{ pkgs, ... }:
{

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = better-escape-nvim;
      type = "lua";
      config = # lua
        ''
          require('better_escape').setup(
            {
              timeout = 200,
              mappings = {
                i = { j = { k = "<Esc>", }, },
                v = { j = { k = "<Esc>", }, },
                t = { j = { k = "<C-\\><C-n>", }, },
              },
            }
          )
        '';
    }
  ];

}
