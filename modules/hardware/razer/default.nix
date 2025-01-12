{ vars, ... }: {

  hardware.openrazer = {
    enable = true;
    users = [ "${vars.username}" ];
    batteryNotifier.enable = false;
  };

  # # NOTE: fixes USB disable issues on boot
  # systemd.services."usb-reset" = {
  #   enable = true;
  #   description = "Reset USB port for Razer Basilisk";
  #   after = [ "multi-user.target" ];
  #   serviceConfig = {
  #     User = "root";
  #     Type = "simple";
  #     ExecStart = pkgs.writeShellScript "unit-restart-usb7_3" ''
  #       echo '7-3' |tee /sys/bus/usb/drivers/usb/unbind
  #       echo '7-3' |tee /sys/bus/usb/drivers/usb/bind
  #     '';
  #     KillMode = "process";
  #     Restart = "on-failure";
  #   };
  #   wantedBy = [ "graphical.target" ];
  # };

}
