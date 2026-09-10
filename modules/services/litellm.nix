{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.litellm;
in
{
  options.custom.services.litellm = {
    enable = lib.mkEnableOption "LiteLLM AI gateway";
    environmentFile = lib.mkOption {
      default = null;
      description = "Environment file containing LiteLLM secrets.";
      type = with lib.types; nullOr path;
    };
    package = lib.mkPackageOption pkgs "litellm" { };
    headroom = {
      enable = lib.mkEnableOption "Headroom context compression service";
      image = lib.mkOption {
        default = "ghcr.io/headroomlabs-ai/headroom:0.37.0@sha256:4e559273659ebc5ce8711a60278e288550fa596377af18a7058e10036d63ef0b";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.litellm = {
      enable = true;
      inherit (cfg) environmentFile package;
      environment = {
        CHATGPT_AUTH_FILE = "auth.json";
        CHATGPT_TOKEN_DIR = "/var/lib/litellm/chatgpt";
      };
      port = 4000;
      settings = {
        litellm_settings = {
          drop_params = true;
          fallbacks = [
            { high = [ "high-opencode" ]; }
            { low = [ "low-deepseek" ]; }
            { low-deepseek = [ "low-opencode" ]; }
            { medium = [ "medium-opencode" ]; }
            { free = [ "free-ollama" ]; }
            { free-ollama = [ "free-opencode" ]; }
          ];
        };
        model_list = [
          {
            model_name = "high";
            model_info.mode = "responses";
            litellm_params.model = "chatgpt/gpt-5.6-sol";
          }
          {
            model_name = "high-opencode";
            litellm_params = {
              api_base = "https://opencode.ai/zen/go/v1";
              api_key = "os.environ/OPENCODE_GO_API_KEY";
              model = "openai/glm-5.3-flash";
              use_chat_completions_api = true;
              extra_headers = {
                "x-opencode-session" = "litellm-pi-bridge";
                "user-agent" = "pi-litellm-bridge/1.0";
              };
            };
          }
          {
            model_name = "medium";
            model_info.mode = "responses";
            litellm_params.model = "chatgpt/gpt-5.6-terra";
          }
          {
            model_name = "medium-opencode";
            litellm_params = {
              api_base = "https://opencode.ai/zen/go/v1";
              api_key = "os.environ/OPENCODE_GO_API_KEY";
              model = "openai/kimi-k2.7-code";
              use_chat_completions_api = true;
              extra_headers = {
                "x-opencode-session" = "litellm-pi-bridge";
                "user-agent" = "pi-litellm-bridge/1.0";
              };
            };
          }
          {
            model_name = "low";
            model_info.mode = "responses";
            litellm_params.model = "chatgpt/gpt-5.6-luna";
          }
          {
            model_name = "low-deepseek";
            litellm_params = {
              api_key = "os.environ/DEEPSEEK_API_KEY";
              model = "deepseek/deepseek-v4-flash";
            };
          }
          {
            model_name = "low-opencode";
            litellm_params = {
              api_base = "https://opencode.ai/zen/go/v1";
              api_key = "os.environ/OPENCODE_GO_API_KEY";
              model = "openai/deepseek-v4-flash";
              use_chat_completions_api = true;
              extra_headers = {
                "x-opencode-session" = "litellm-pi-bridge";
                "user-agent" = "pi-litellm-bridge/1.0";
              };
            };
          }
          {
            model_name = "free";
            litellm_params = {
              api_key = "os.environ/OPENROUTER_API_KEY";
              model = "openrouter/openrouter/free";
            };
          }
          {
            model_name = "free-ollama";
            litellm_params = {
              api_base = "https://ollama.com";
              api_key = "os.environ/OLLAMA_API_KEY";
              model = "ollama/gpt-oss:120b";
            };
          }
          {
            model_name = "free-opencode";
            model_info.mode = "responses";
            litellm_params = {
              api_base = "https://opencode.ai/zen/v1";
              api_key = "none";
              extra_headers.x-opencode-client = "desktop";
              model = "openai/muse-spark-1.3-contributor-free";
            };
          }
        ];
        router_settings = {
          allowed_fails = 1;
          num_retries = 0;
          routing_strategy = "simple-shuffle";
        };
      };
    };

    systemd.tmpfiles.rules = lib.optionals cfg.headroom.enable [
      "d /var/lib/headroom 0700 1000 1000 -"
    ];

    virtualisation = lib.mkIf cfg.headroom.enable {
      docker.enable = lib.mkDefault true;
      oci-containers = {
        backend = lib.mkDefault "docker";
        containers.headroom = {
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
}
