{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons
    {
      plugin = lualine-nvim;
      type = "lua";
      config = # lua
        ''
          require('lualine').setup({
            options = {
              globalstatus = true,
              component_separators = { left = '󰿟', right = ''},
              section_separators = { left = '', right = ''},
            },
            sections = {
              lualine_b = {
                {
                  "branch",
                  icon = "",
                  fmt = function(str)
                     if str:len() > 25 then
                        return str:sub(1, 25) .. '>'
                     end
                     return str
                  end,
                },
                {
                  "diff",
                  symbols = {added = '', modified = '󰟃', removed = ''},
                },
                {
                  "diagnostics",
                  symbols = {error = '', warn = '', info = '', hint = ''},
                }
              },
            },
          })
        '';
    }
  ];

}
