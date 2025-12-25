{ lib, ... }:
{

  options.custom-hm.user = {

    editor = lib.mkOption {
      default = "vi";
      type = lib.types.str;
    };

  };

}
