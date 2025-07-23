{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.peripherals.zsa;
in
{

  options.custom.hardware.peripherals.zsa = {
    enable = lib.mkEnableOption "ZSA bundle";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.zsa.enable = true;
    environment.systemPackages = with pkgs; [ keymapp ];
  };

}
