{ pkgs, vars, ... }: {
  # boot.kernelModules = [ "uinput" ];
  # services.udev.extraRules = ''
  #   # KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  #   KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  # '';

  services.xremap = {
    # withGnome = true;
    # withWlroots = true;
    # serviceMode = "user";
    userName = vars.username;
    config = {
      virtual_modifiers = [ "capslock" ];
      # modmap = [{
      #   name = "fix broken shift key";
      #   remap = { capslock = "shift_l"; };
      # }];
      keymap = [
        # {
        #   name = "desktop apps";
        #   remap = {
        #     shift-super-h.launch = [ "${vars.terminal.name}" "-e" "htop" ];
        #     shift-super-n.launch = [ "${vars.terminal.name}" "-e" "nvtop" ];
        #     super-enter.launch = [ "${vars.terminal.name}" ];
        #     shift-super-e.launch = [ "nautilus" ];
        #     shift-super-z.launch = [ "zathura" ];
        #     shift-super-s.launch =
        #       [ "kitty" "-o" "term=xterm-kitty" "-e" "spotify_player" ];
        #     shift-super-p.launch =
        #       [ "${vars.terminal.name}" "-e" "spotify_player" ];
        #   };
        # }
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
