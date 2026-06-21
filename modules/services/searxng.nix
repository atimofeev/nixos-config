{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.searxng;
in
{
  options.custom.services.searxng = {
    enable = lib.mkEnableOption "searxng bundle";

    port = lib.mkOption {
      default = 8080;
      type = lib.types.port;
      description = "Port for SearXNG HTTP server.";
    };

    bindAddress = lib.mkOption {
      default = "127.0.0.1";
      type = lib.types.str;
      description = "Bind address. Use 0.0.0.0 for LAN access.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.searx = {
      enable = true;
      package = pkgs.searxng;
      configureNginx = false;
      configureUwsgi = false;
      redisCreateLocally = false;
      openFirewall = cfg.bindAddress != "127.0.0.1";

      settings = {
        general = {
          instance_name = "searxng";
          debug = false;
        };

        search = {
          autocomplete = "google";
          formats = [
            "html"
            "json"
          ];
          # Shorter suspensions — laptop has residential IP, transient blocks recover fast
          suspended_times = {
            SearxEngineAccessDenied = 60;
            SearxEngineCaptcha = 1800;
            SearxEngineTooManyRequests = 60;
            cf_SearxEngineCaptcha = 86400;
            cf_SearxEngineAccessDenied = 3600;
            recaptcha_SearxEngineCaptcha = 86400;
          };
        };

        server = {
          port = cfg.port;
          bind_address = cfg.bindAddress;
          secret_key = "a2fb23f1b02e6ee83875b09826990de0f6bd908b6638e8c10277d415f6ab852b";
          limiter = false;
          public_instance = false;
          image_proxy = false;
          method = "POST";
        };

        ui = {
          default_theme = "simple";
          default_locale = "";
        };

        outgoing = {
          request_timeout = 5.0;
          max_request_timeout = 10.0;
          enable_http2 = true;
          # Browser-like headers — helps with engines that check headers
          # (DuckDuckGo, Bing, Brave, Qwant). Google sets its own UA in engine code.
          request_headers = {
            Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8";
            Accept-Language = "en-US,en;q=0.9";
            "Sec-Fetch-Dest" = "document";
            "Sec-Fetch-Mode" = "navigate";
            "Sec-Fetch-Site" = "none";
            "Sec-Fetch-User" = "?1";
            "Upgrade-Insecure-Requests" = "1";
          };
        };

        engines = [
          { name = "google"; disabled = false; }
          { name = "bing"; disabled = false; }
          { name = "duckduckgo"; disabled = false; }
          { name = "brave"; disabled = false; }
          { name = "qwant"; disabled = false; }
          { name = "mojeek"; disabled = false; }
          { name = "startpage"; disabled = false; }
          { name = "wolframalpha"; disabled = false; }
        ];
      };
    };
  };
}
