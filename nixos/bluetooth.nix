_: {
  hardware.bluetooth = {
    enable = true;
    settings = {

      Policy.AutoEnable = true;

      General = {
        ControllerMode = "bredr"; # Fixes Marshall Motif II LE mode
        # NOTE: trying to fix headset vs handsfree sources availability
        # Experimental = true; 
        # KernelExperimental = true;
      };

    };
  };
}
