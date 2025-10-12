{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.custom.hardware.peripherals.motiff-ii-fix;

  reconnect-motif2 = pkgs.pkgs.writeShellScript "reconnect-motif2" ''
    bluetoothctl disconnect 00:25:D1:37:8C:19
    sleep 3
    bluetoothctl connect 00:25:D1:37:8C:19'';
  reconnect-motif2-exec = "systemd-run --user ${reconnect-motif2}";

in
{

  options.custom.hardware.peripherals.motiff-ii-fix = {
    enable = lib.mkEnableOption "Fix compatibility with Marshall Motiff II";
  };

  config = lib.mkIf cfg.enable {

    hardware.bluetooth.settings.General.ControllerMode = lib.mkDefault "bredr";

    # NOTE: reconnect to fix stuck handsfree on Marshall Motif II
    home-manager.users.${vars.username} = {
      programs.fish.shellAliases.reconnect-motif2 = reconnect-motif2-exec;
      wayland.windowManager.hyprland.settings.bind = [ "SUPER, R, exec, ${reconnect-motif2-exec}" ];
    };
  };

}
