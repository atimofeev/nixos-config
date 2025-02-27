{ vars, hostname, ... }: {

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  users.users.${vars.username}.extraGroups = [ "networkmanager" ];

  services.resolved = {
    enable = true;
    fallbackDns =
      [ "1.1.1.1" "2606:4700:4700::1111" "8.8.8.8" "2001:4860:4860::8844" ];
  };

}
