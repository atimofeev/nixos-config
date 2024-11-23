{ pkgs, ... }:
let
  # TODO: setup
  # https://github.com/mikesmithgh/kitty-scrollback.nvim
  kitty-scrollback-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "kitty-scrollback.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mikesmithgh";
      repo = "kitty-scrollback.nvim";
      rev = "dc101d0a8356db9c7290dfbfa82c27ec35e3b55a";
      hash = "sha256-TV++v8aH0Vi9UZEdTT+rUpu6HKAfhu04EwAgGbfk614=";
    };
  };
in {
  programs = {
    neovim.plugins = [{
      plugin = kitty-scrollback-nvim;
      type = "lua";
      config = ''
        require('kitty-scrollback').setup()
      '';
    }];

    kitty.extraConfig = # conf
      ''
        allow_remote_control socket-only
        listen_on unix:/tmp/kitty
        shell_integration enabled

        action_alias kitty_scrollback_nvim kitten ${kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py

        # Browse scrollback buffer in nvim
        map kitty_mod+h kitty_scrollback_nvim
        # Browse output of the last shell command in nvim
        map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
        # Show clicked command output in nvim
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
      '';

  };
}
