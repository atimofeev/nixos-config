{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.litellm;

  # LiteLLM DeepSeek reasoning: see https://github.com/BerriAI/litellm/issues/27439
  # Preferred fix: https://github.com/BerriAI/litellm/pull/38736
  # OPEN: an effort value outside this list makes the proxy answer HTTP 200 with a
  # body of literally `null` instead of forwarding DeepSeek's 422.
  # https://github.com/BerriAI/litellm/issues/32221 (corroborated for 1.98.0)
  deepSeekReasoningInfo = {
    reasoning_effort_levels = [
      "none"
      "minimal"
      "low"
      "medium"
      "high"
      "xhigh"
      "max"
    ];
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_reasoning = true;
  };
  kimiK3ReasoningInfo = {
    max_input_tokens = 1048576;
    max_output_tokens = 131072;
    reasoning_effort_levels = [
      "none"
      "minimal"
      "low"
      "medium"
      "high"
      "xhigh"
      "max"
    ];
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_reasoning = true;
  };
  qwen38ReasoningInfo = {
    max_input_tokens = 1000000;
    max_output_tokens = 131072;
    reasoning_effort_levels = [
      "none"
      "minimal"
      "low"
      "medium"
      "high"
      "xhigh"
      "max"
    ];
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_reasoning = true;
  };
  # Every fallback target speaks chat completions only. Without this the client
  # negotiates /v1/responses from the ChatGPT primary's identity, then LiteLLM's
  # bridge loses multi-turn tool calls and exposes reasoning as assistant text.
  # Keep this pin: pi-provider-litellm's maintainer confirmed it is the supported
  # workaround because fallback targets are invisible during model discovery.
  #   bridge bug: https://github.com/BerriAI/litellm/issues/42005
  #   earlier protocol/401 bug: https://github.com/BerriAI/litellm/issues/41385
  #   client discussion: https://github.com/balcsida/pi-provider-litellm/issues/191
  # Pi will warn from x-litellm-attempted-fallbacks in a future release; verify
  # the warning after updating the extension. Do not infer tool calls from JSON
  # text or globally strip <think>: both can reinterpret legitimate model output.
  # TODO: recheck the supports_* claims below once the codex quota resets; they
  # are unverifiable while every ChatGPT route answers 429 usage_limit_reached.
  openAIReasoningOverrides = {
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_max_reasoning_effort = true;
    supports_minimal_reasoning_effort = false;
    supports_xhigh_reasoning_effort = true;
  };
  gptOssReasoningInfo = {
    max_input_tokens = 131072;
    max_output_tokens = 65536;
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_reasoning = false;
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
          # Chains cross model families, so a 200 here does not mean the route is
          # healthy: probe individual routes with `disable_fallbacks: true` or a
          # broken primary stays hidden behind whichever target answers. Inspect
          # x-litellm-attempted-fallbacks, x-litellm-model-group and
          # x-litellm-model-name to identify the deployment that actually served.
          # pi-provider-litellm cannot discover this graph from /model/info; keep
          # each public alias pinned to chat completions above.
          # `free-opencode` is deliberately absent: opencode.ai/zen/v1 answers 403
          # FreeTierError ("can only be used from within OpenCode") on every call.
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
              free = [ "free-ollama" ];
            }
            {
              "*" = [ "free-ollama" ];
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
              use_chat_completions_api = true;
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
              use_chat_completions_api = true;
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
            # Stock LiteLLM DeepSeek adapter collapses reasoning_effort to binary
            # thinking.enabled. Use generic OpenAI adapter so Pi's selector reaches
            # DeepSeek unchanged. See https://github.com/BerriAI/litellm/issues/27439
            # and https://github.com/BerriAI/litellm/pull/38736.
            model_info = deepSeekReasoningInfo;
            litellm_params = {
              allowed_openai_params = [ "reasoning_effort" ];
              api_base = "https://api.deepseek.com/beta";
              api_key = "os.environ/DEEPSEEK_API_KEY";
              model = "openai/deepseek-v4-flash";
              use_chat_completions_api = true;
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
            # Ollama's OpenAI-compatible endpoint, not the native one: LiteLLM's
            # ollama adapter ignores the JSON `thinking` field on non-streaming
            # replies, so gpt-oss answers arrive with empty content.
            # https://github.com/BerriAI/litellm/issues/41962 (filed; the earlier
            # https://github.com/BerriAI/litellm/issues/27956 was closed stale on a
            # premise that no longer holds). Revert to ollama/ once that lands.
            litellm_params = {
              api_base = "https://ollama.com/v1";
              api_key = "os.environ/OLLAMA_API_KEY";
              model = "openai/gpt-oss:120b";
              use_chat_completions_api = true;
            };
          }
        ];
        router_settings = {
          # allowed_fails = 1 with one deployment per model_name means the first
          # failure cools the route, and later requests report "No deployments
          # available, try again in 5 seconds" instead of the real upstream error.
          # Space probes out when diagnosing, or read only the first error.
          # https://github.com/BerriAI/litellm/issues/40405
          # https://github.com/BerriAI/litellm/issues/40130
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
