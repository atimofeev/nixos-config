{ vars, ... }: {

  networking.firewall = {
    allowedTCPPorts = [ 53 80 ];
    allowedUDPPorts = [ 53 67 ];
  };

  # NOTE: access through http://pi.hole/admin/
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:2024.07.0";
    autoStart = true;
    environment = {
      TZ = vars.tz_name;
      WEBPASSWORD = "test";
    };
    ports = [ "53:53/tcp" "53:53/udp" "80:80/tcp" ];
    volumes = [ "pihole:/etc/pihole" "pihole-dnsmasq:/etc/dnsmasq.d" ];
    extraOptions = [ "--network=host" "--cap-add=NET_ADMIN" ];
  };

}
