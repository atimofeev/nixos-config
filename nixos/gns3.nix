{ pkgs, vars, ... }: {
  virtualisation.vmware.host.enable = true;
  environment.systemPackages = with pkgs; [
    gns3-server
    gns3-gui
    ubridge
    dynamips
    libvirt
    vpcs
  ];

  # ubridge requires capabilities to function
  users.groups.ubridge = { };
  users.users.${vars.username}.extraGroups = [ "ubridge" ];
  security.wrappers.ubridge = {
    source = "/run/current-system/sw/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "ubridge";
    permissions = "u+rx,g+x";
  };
  # in ~/.config/GNS3/2.2/gns3_server.conf
  # update "ubridge_path = /run/wrappers/bin/ubridge" 
}
