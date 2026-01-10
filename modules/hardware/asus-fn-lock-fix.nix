{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.asus-fn-lock-fix;

in
{

  imports = [ inputs.asus-px-keyboard-tool.nixosModules.default ];

  options.custom.hardware.asus-fn-lock-fix = {
    enable = lib.mkEnableOption "Enables fn-lock by default on Asus GU605CR";
  };

  config = lib.mkIf cfg.enable {

    services.asus-px-keyboard-tool = {
      enable = true;
      settings = {
        fnlock = {
          enabled = true;
          boot_default = "on";
        };
      };
    };

    systemd.services.asus-px-keyboard-tool = {
      serviceConfig = {
        Restart = lib.mkForce "always";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

  };

}
