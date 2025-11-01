{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.bluetooth;
in
{

  options.custom.hardware.bluetooth = {
    enable = lib.mkEnableOption "bluetooth bundle";
  };

  config = lib.mkIf cfg.enable {
    services.blueman.enable = true;

    home-manager.users = lib.attrsets.genAttrs config.custom.hm-users (u: {
      services.blueman-applet.enable = true;
    });

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
  };

}
