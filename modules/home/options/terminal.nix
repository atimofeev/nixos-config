{ lib, ... }:
{

  options.custom-hm.user = {

    terminal = lib.mkOption {
      default = "kitty";
      type = lib.types.str;
    };

  };

}
