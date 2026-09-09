{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services."9router";
in
{
  options.custom.services."9router" = {
    enable = lib.mkEnableOption "9Router AI gateway";
    headroom = {
      enable = lib.mkEnableOption "Headroom context compression";
      image = lib.mkOption {
        default = "ghcr.io/headroomlabs-ai/headroom:0.37.0@sha256:4e559273659ebc5ce8711a60278e288550fa596377af18a7058e10036d63ef0b";
        type = lib.types.str;
      };
    };
    image = lib.mkOption {
      default = "ghcr.io/decolua/9router:0.5.69@sha256:47c17576ad49f0918d1a455dd412ae4509ee8bc742f17ba0b3327ddc70f35a40";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # Headroom image runs as uid/gid 1000.
    systemd.tmpfiles.rules = [
      "d /var/lib/9router 0700 root root -"
    ]
    ++ lib.optionals cfg.headroom.enable [
      "d /var/lib/headroom 0700 1000 1000 -"
    ];

    virtualisation = {
      docker.enable = lib.mkDefault true;
      oci-containers = {
        backend = lib.mkDefault "docker";
        containers = {
          "9router" = {
            inherit (cfg) image;
            autoStart = true;
            dependsOn = lib.optional cfg.headroom.enable "headroom";
            environment = {
              BASE_URL = "http://127.0.0.1:20128";
              DATA_DIR = "/app/data";
              HOSTNAME = "127.0.0.1";
              NEXT_PUBLIC_BASE_URL = "http://127.0.0.1:20128";
              NEXT_TELEMETRY_DISABLED = "1";
              NODE_ENV = "production";
              PORT = "20128";
            }
            // lib.optionalAttrs cfg.headroom.enable {
              HEADROOM_URL = "http://127.0.0.1:8787";
            };
            extraOptions = [ "--network=host" ];
            volumes = [ "/var/lib/9router:/app/data" ];
          };

          headroom = lib.mkIf cfg.headroom.enable {
            inherit (cfg.headroom) image;
            autoStart = true;
            cmd = [
              "--host"
              "127.0.0.1"
              "--port"
              "8787"
            ];
            environment = {
              HEADROOM_CONFIG_DIR = "/home/nonroot/.headroom/config";
              HEADROOM_HOST = "127.0.0.1";
              HEADROOM_PORT = "8787";
              HEADROOM_WORKSPACE_DIR = "/home/nonroot/.headroom";
              HOME = "/home/nonroot";
            };
            extraOptions = [ "--network=host" ];
            volumes = [ "/var/lib/headroom:/home/nonroot/.headroom" ];
          };
        };
      };
    };
  };
}
