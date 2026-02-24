{ config, lib, ... }:
let
  cfg = config.custom-hm.user;
in
{

  options.custom-hm.user = {

    terminal = lib.mkOption {
      default = "kitty";
      type = lib.types.str;
    };

  };

  config = {
    home.sessionVariables.TERMINAL = cfg.terminal;
  };

}
