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
  programs.neovim.plugins = [{
    plugin = kitty-scrollback-nvim;
    type = "lua";
    # config = ''
    #   -- require('test').setup()
    # '';
  }];
}
