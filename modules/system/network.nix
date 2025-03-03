{ vars, ... }: {

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  users.users.${vars.username}.extraGroups = [ "networkmanager" ];

  services.resolved = {
    enable = true;
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

}
