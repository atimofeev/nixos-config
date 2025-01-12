{ vars, hostname, ... }: {

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  users.users.${vars.username}.extraGroups = [ "networkmanager" ];

}
