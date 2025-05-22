{ inputs, vars, ... }:
{

  imports = [ inputs.xremap.nixosModules.default ];

  services.xremap = {
    userName = vars.username;
    watch = true;
    config = {
      virtual_modifiers = [ "capslock" ];
      modmap = [
        {
          name = "capslock tap = esc";
          remap = {
            capslock = {
              held = "capslock";
              alone = "esc";
            };
          };
        }
        # NOTE: not actually feasible at the moment
        # xremap default behavior is `hold-preferred`
        # https://github.com/xremap/xremap/issues/238
        # https://zmk.dev/docs/keymaps/behaviors/hold-tap#flavors
        # {
        #   name = "home row mods";
        #   remap = {
        #     a = {
        #       held = "super_l";
        #       alone = "a";
        #     };
        #     s = {
        #       held = "alt_l";
        #       alone = "s";
        #     };
        #     d = {
        #       held = "shift_l";
        #       alone = "d";
        #     };
        #     f = {
        #       held = "ctrl_l";
        #       alone = "f";
        #     };
        #   };
        # }
      ];
      keymap = [
        {
          name = "hjkl anywhere";
          remap = {
            capslock-h = "left";
            capslock-j = "down";
            capslock-k = "up";
            capslock-l = "right";
          };
        }
      ];
    };
  };
}
