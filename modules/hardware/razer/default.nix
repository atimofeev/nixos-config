{ vars, ... }: {

  hardware.openrazer = {
    enable = true;
    users = [ "${vars.username}" ];
    batteryNotifier.enable = false;
  };

}
