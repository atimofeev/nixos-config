{ pkgs, vars, ... }:
{
  users.users.${vars.username}.extraGroups = [ "libvirtd" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [ gnome.gnome-boxes ];

  home-manager.users.${vars.username} = {
    # Autoconnect for virt-manager
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

}
