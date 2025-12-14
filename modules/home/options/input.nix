{ lib, ... }:
{

  options.custom-hm.user = {

    input = {

      repeat-delay = lib.mkOption {
        default = 660;
        type = lib.types.int;
      };

      repeat-rate = lib.mkOption {
        default = 25;
        type = lib.types.int;
      };

      mouse-sensitivity = lib.mkOption {
        default = 0;
        type = lib.types.float;
      };

      touchpad-sensitivity = lib.mkOption {
        default = 0;
        type = lib.types.float;
      };

      xkb = {
        layout = lib.mkOption {
          default = "us";
          type = lib.types.str;
        };
        options = lib.mkOption {
          default = "";
          type = lib.types.str;
        };
      };

    };

  };

}
