{ pkgs, vars, ... }: {

  environment.systemPackages = [ pkgs.bluetuith ];

  services.blueman.enable = true;

  home-manager.users.${vars.username}.services.blueman-applet.enable = true;

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
