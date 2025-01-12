_: {

  hardware.bluetooth = {
    enable = true;
    settings = {

      Policy.AutoEnable = true;

      General = {
        FastConnectable = true;
        Experimental = true;
        KernelExperimental = true;
      };

    };
  };

}
