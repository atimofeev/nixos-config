{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.litellm;

  deepSeekReasoningInfo = {
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = true;
    supports_minimal_reasoning_effort = true;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = true;
  };
  kimiK3ReasoningInfo = {
    max_input_tokens = 1048576;
    max_output_tokens = 131072;
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_high_reasoning_effort = true;
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = true;
    supports_medium_reasoning_effort = false;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = false;
  };
  qwen38ReasoningInfo = {
    max_input_tokens = 1000000;
    max_output_tokens = 131072;
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_high_reasoning_effort = false;
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = false;
    supports_medium_reasoning_effort = true;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = true;
  };
  openAIReasoningOverrides = {
    supports_high_reasoning_effort = true;
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = true;
    supports_medium_reasoning_effort = true;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = true;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = true;
  };
  gptOssReasoningInfo = {
    max_input_tokens = 131072;
    max_output_tokens = 65536;
    supports_low_reasoning_effort = false;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
  };
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
            {
              high = [
                "high-opencode"
                "free"
              ];
            }
            {
              medium = [
                "medium-opencode"
                "free"
              ];
            }
            {
              low = [
                "low-deepseek"
                "low-opencode"
                "free"
              ];
            }
            {
              free = [
                "free-ollama"
                "free-opencode"
              ];
            }
          ];
        };
        model_list = [
          {
            model_name = "high";
            model_info = openAIReasoningOverrides;
            litellm_params.model = "chatgpt/gpt-5.6-sol";
          }
          {
            model_name = "high-opencode";
            model_info = kimiK3ReasoningInfo;
            litellm_params = {
              allowed_openai_params = [ "reasoning_effort" ];
              api_base = "https://opencode.ai/zen/go/v1";
              api_key = "os.environ/OPENCODE_GO_API_KEY";
              model = "openai/kimi-k3";
              extra_headers = {
                "x-opencode-session" = "litellm-pi-bridge";
                "user-agent" = "pi-litellm-bridge/1.0";
              };
            };
          }
          {
            model_name = "medium";
            model_info = openAIReasoningOverrides;
            litellm_params.model = "chatgpt/gpt-5.6-terra";
          }
          {
            model_name = "medium-opencode";
            model_info = qwen38ReasoningInfo;
            litellm_params = {
              allowed_openai_params = [ "reasoning_effort" ];
              api_base = "https://opencode.ai/zen/go/v1";
              api_key = "os.environ/OPENCODE_GO_API_KEY";
              model = "openai/qwen3.8-max";
              extra_headers = {
                "x-opencode-session" = "litellm-pi-bridge";
                "user-agent" = "pi-litellm-bridge/1.0";
              };
            };
          }
          {
            model_name = "low";
            model_info = openAIReasoningOverrides;
            litellm_params.model = "chatgpt/gpt-5.6-luna";
          }
          {
            model_name = "low-deepseek";
            model_info = deepSeekReasoningInfo;
            litellm_params = {
              api_key = "os.environ/DEEPSEEK_API_KEY";
              model = "deepseek/deepseek-v4-flash";
            };
          }
          {
            model_name = "low-opencode";
            model_info = qwen38ReasoningInfo;
            litellm_params = {
              allowed_openai_params = [ "reasoning_effort" ];
              api_base = "https://opencode.ai/zen/go/v1";
              api_key = "os.environ/OPENCODE_GO_API_KEY";
              model = "openai/qwen3.8-flash";
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
            model_info = gptOssReasoningInfo;
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
              api_key = "public";
              extra_headers = {
                x-opencode-client = "desktop";
                x-opencode-session = "litellm-pi-bridge";
              };
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

    systemd = {
      services.litellm.serviceConfig.TimeoutStopSec = "10s";
      tmpfiles.rules = lib.optionals cfg.headroom.enable [
        "d /var/lib/headroom 0700 1000 1000 -"
      ];
    };

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
