{ vars, ... }: {

  home-manager.users.${vars.username} = {

    # NOTE: fix stuck handsfree on Marshall Motiff II
    programs.fish.shellAliases.reconnect-motiff2 = ''
      bluetoothctl disconnect 00:25:D1:37:8C:19 && \
      sleep 3 && \
      bluetoothctl connect 00:25:D1:37:8C:19'';

  };

}
