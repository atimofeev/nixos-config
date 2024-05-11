{ vars, ... }: {
  networking = {
    hostName = vars.hostname;
    networkmanager.enable = true;
  };

  users.users.${vars.username}.extraGroups = [ "networkmanager" ];
}
