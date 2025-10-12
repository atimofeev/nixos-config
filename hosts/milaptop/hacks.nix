{ pkgs, vars, ... }:
let
  reconnect-motif2 = pkgs.pkgs.writeShellScript "reconnect-motif2" ''
    bluetoothctl disconnect 00:25:D1:37:8C:19
    sleep 3
    bluetoothctl connect 00:25:D1:37:8C:19'';
  reconnect-motif2-exec = "systemd-run --user ${reconnect-motif2}";
in
{

  home-manager.users.${vars.username} = {

    # NOTE: fix stuck handsfree on Marshall Motif II
    programs.fish.shellAliases.reconnect-motif2 = reconnect-motif2-exec;

    wayland.windowManager.hyprland.settings.bind = [ "SUPER, R, exec, ${reconnect-motif2-exec}" ];

  };

}
