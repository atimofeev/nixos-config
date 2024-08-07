{ vars, ... }: {
  services.xremap = {
    userName = vars.username;
    config = {
      virtual_modifiers = [ "capslock" ];
      modmap = [{
        name = "capslock tap = esc";
        remap = {
          capslock = {
            held = "capslock";
            alone = "esc";
          };
        };
      }];
      keymap = [{
        name = "hjkl anywhere";
        remap = {
          capslock-h = "left";
          capslock-j = "down";
          capslock-k = "up";
          capslock-l = "right";
        };
      }];
    };
  };
}
