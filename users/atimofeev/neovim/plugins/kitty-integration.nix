{ pkgs, ... }:
{
  programs = {

    neovim = {
      extraLuaConfig = # lua
        ''
          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost" }, {
            desc = "Update kitty tab title with current filename",
            callback = function()
              vim.fn.system { "kitty", "@", "set-tab-title", vim.fn.expand "%:t" }
            end,
          })'';
      plugins = with pkgs.vimPlugins; [
        # TODO: setup
        # https://github.com/mikesmithgh/kitty-scrollback.nvim
        {
          plugin = kitty-scrollback-nvim;
          type = "lua";
          config = ''
            require('kitty-scrollback').setup()
          '';
        }
      ];
    };

    kitty.extraConfig = # conf
      ''
        allow_remote_control socket-only
        listen_on unix:/tmp/kitty
        shell_integration enabled

        action_alias kitty_scrollback_nvim kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py

        # Browse scrollback buffer in nvim
        map kitty_mod+h kitty_scrollback_nvim
        # Browse output of the last shell command in nvim
        map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
        # Show clicked command output in nvim
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
      '';

  };
}
