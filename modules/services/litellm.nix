{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.litellm;

  deepSeekReasoningInfo = {
    supports_high_reasoning_effort = true;
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = true;
    supports_medium_reasoning_effort = true;
    supports_minimal_reasoning_effort = true;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = true;
  };
  deepSeekOpenCodeInfo = deepSeekReasoningInfo // {
    max_input_tokens = 1000000;
    max_output_tokens = 393216;
  };
  glmReasoningInfo = {
    max_input_tokens = 1000000;
    max_output_tokens = 131072;
    supports_high_reasoning_effort = false;
    supports_low_reasoning_effort = false;
    supports_max_reasoning_effort = true;
    supports_medium_reasoning_effort = false;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = false;
  };
  openAIReasoningInfo = {
    max_input_tokens = 272000;
    max_output_tokens = 128000;
    mode = "responses";
    supports_high_reasoning_effort = true;
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = true;
    supports_medium_reasoning_effort = true;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = true;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = true;
  };
  kimiReasoningInfo = {
    max_input_tokens = 262144;
    max_output_tokens = 32768;
    supports_high_reasoning_effort = false;
    supports_low_reasoning_effort = false;
    supports_max_reasoning_effort = false;
    supports_medium_reasoning_effort = false;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = false;
  };
  gptOssReasoningInfo = {
    max_input_tokens = 131072;
    max_output_tokens = 65536;
    supports_high_reasoning_effort = false;
    supports_low_reasoning_effort = false;
    supports_max_reasoning_effort = false;
    supports_medium_reasoning_effort = false;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = false;
    supports_reasoning = true;
    supports_xhigh_reasoning_effort = false;
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
            model_info = openAIReasoningInfo;
            litellm_params.model = "chatgpt/gpt-5.6-sol";
          }
          {
            model_name = "high-opencode";
            model_info = glmReasoningInfo;
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
            model_info = openAIReasoningInfo;
            litellm_params.model = "chatgpt/gpt-5.6-terra";
          }
          {
            model_name = "medium-opencode";
            model_info = kimiReasoningInfo;
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
            model_info = openAIReasoningInfo;
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
            model_info = deepSeekOpenCodeInfo;
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
