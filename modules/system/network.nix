{ pkgs, vars, ... }: {

  # Bypass hotspot restrictions for certain ISPs
  boot.kernel.sysctl = {
    "net.ipv4.ip_default_ttl" = 65;
    "net.ipv6.conf.all.hop_limit" = 65;
    "net.ipv6.conf.default.hop_limit" = 65;
    "net.ipv6.conf.*.hop_limit" = 65;
  };

  users.users.${vars.username}.extraGroups = [ "networkmanager" ];

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    plugins = [ pkgs.networkmanager-openvpn ];
    unmanaged = [ "docker*" ];
  };

  programs.nm-applet.enable = true;

  services.resolved.enable = true;

}
