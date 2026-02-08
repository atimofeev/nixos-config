{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services.netbootxyz;
in
{

  options.custom.services.netbootxyz = {
    enable = lib.mkEnableOption "netbootxyz bundle";
    image = lib.mkOption {
      default = "ghcr.io/netbootxyz/netbootxyz:pr-112-ac583451bb83d8dffe4766bf5d35ec192b41b9ed ";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedUDPPorts = [ 69 ];

    virtualisation.oci-containers.containers.netbootxyz = {
      inherit (cfg) image;
      autoStart = true;
      environment = {
        NGINX_PORT = "80";
        WEB_APP_PORT = "3000";
      };
      ports = [
        "3000:3000"
        "69:69/udp" # tftp
        "8080:80"
      ];
      volumes = [
        "netbootxyz-config:/config"
        "netbootxyz-assets:/assets"
      ];
    };
  };

}
