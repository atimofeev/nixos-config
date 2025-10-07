{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services.pihole;
in
{

  options.custom.services.pihole = {
    enable = lib.mkEnableOption "pihole bundle";
    image = lib.mkOption {
      default = "pihole/pihole:2024.07.0";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        53
        80
      ];
      allowedUDPPorts = [
        53
        67
      ];
    };

    # NOTE: access through http://pi.hole/admin/
    virtualisation.oci-containers.containers.pihole = {
      inherit (cfg) image;
      autoStart = true;
      environment = {
        TZ = config.time.timeZone;
        WEBPASSWORD = "test";
      };
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "80:80/tcp"
      ];
      volumes = [
        "pihole:/etc/pihole"
        "pihole-dnsmasq:/etc/dnsmasq.d"
      ];
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
      ];
    };
  };

}
