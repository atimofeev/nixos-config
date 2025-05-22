{ pkgs, ... }:
let
  # TODO: setup
  # https://github.com/mikesmithgh/kitty-scrollback.nvim
  kitty-scrollback-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "kitty-scrollback.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mikesmithgh";
      repo = "kitty-scrollback.nvim";
      rev = "d52825b2a076586d1af156a066db2d18cd1fd8cb";
      hash = "sha256-PpBaVuZqlU5A9a7ryEvs5TcsM/uz3dzx7KGjA3tt3NU=";
    };
  };
in
{
  programs = {
    neovim.plugins = [
      {
        plugin = kitty-scrollback-nvim;
        type = "lua";
        config = ''
          require('kitty-scrollback').setup()
        '';
      }
    ];

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
