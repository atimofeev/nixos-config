# TODO: expose port config & add it to homepage
# TODO: expose image config
{ lib, config, ... }:
let
  cfg = config.custom.services.convertx;
in
{

  options.custom.services.convertx = {
    enable = lib.mkEnableOption "convertx bundle";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.convertx = {
      image = "ghcr.io/c4illin/convertx";
      autoStart = true;
      environment = {
        HTTP_ALLOWED = "true";
        ALLOW_UNAUTHENTICATED = "true";
      };
      ports = [ "3000:3000" ];
      volumes = [ "convertx:/app/data" ];
    };
  };

}
