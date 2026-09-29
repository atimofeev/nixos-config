{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.litellm;

  routeChains = {
    free = [
      "free-openrouter"
      "free-ollama"
      "free-gemini"
    ];
    high = [
      "high-codex"
      "high-opencode"
      "low-deepseek"
      "free"
    ];
    low = [
      "low-deepseek"
      "low-codex"
      "low-opencode"
      "free"
    ];
    medium = [
      "medium-codex"
      "medium-opencode"
      "low-deepseek"
      "free"
    ];
  };

  baseReasoningInfo = {
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

  openCodeParams = {
    allowed_openai_params = [ "reasoning_effort" ];
    api_base = "https://opencode.ai/zen/go/v1";
    api_key = "os.environ/OPENCODE_GO_API_KEY";
    use_chat_completions_api = true;
    extra_headers."x-opencode-session" = "litellm-pi-bridge";
  };

  # LiteLLM DeepSeek reasoning: see https://github.com/BerriAI/litellm/issues/27439
  # Preferred fix: https://github.com/BerriAI/litellm/pull/38736
  # OPEN: an effort value outside this list makes the proxy answer HTTP 200 with a
  # body of literally `null` instead of forwarding DeepSeek's 422.
  # https://github.com/BerriAI/litellm/issues/32221 (corroborated for 1.98.0)
  deepSeekReasoningInfo = baseReasoningInfo;

  kimiK3ReasoningInfo = baseReasoningInfo // {
    max_input_tokens = 1048576;
    max_output_tokens = 131072;
  };

  qwen38ReasoningInfo = baseReasoningInfo // {
    max_input_tokens = 1000000;
    max_output_tokens = 131072;
  };

  # Every fallback target speaks chat completions only, so the fallback graph has
  # to be bridged server-side. LiteLLM 1.100.1 bridges /v1/responses to chat-only
  # deployments correctly, including native tool calls, so the ChatGPT primaries
  # stay on the Responses API: that is the only path the official Codex client
  # uses, and it is not probed by Cloudflare. Verified 2026-09-21 against this
  # proxy on 1.100.1:
  #   /v1/responses  model=high          -> chatgpt/gpt-5.6-sol, fallbacks=0
  #   /v1/chat/...   model=high          -> Cloudflare managed challenge on
  #     https://chatgpt.com/backend-api/codex/chat/completions, fallbacks=1
  #   /v1/responses  model=low-deepseek  -> openai/deepseek-v4-flash, function_call intact
  # The old chat-completions pin below caused the Cloudflare challenge and is gone.
  #   bridge regression (fixed on main, closed):
  #     https://github.com/BerriAI/litellm/issues/42005
  #   request-side regression tests: https://github.com/BerriAI/litellm/pull/42129
  #   earlier protocol/401 bug (still open):
  #     https://github.com/BerriAI/litellm/issues/41385
  #   client discussion: https://github.com/balcsida/pi-provider-litellm/issues/191
  #   fallback warning: https://github.com/balcsida/pi-provider-litellm/pull/195
  # Shipped in pi-provider-litellm 3.2.0 (merge 1fb530f, released 2026-09-23): on a
  # 2xx whose x-litellm-attempted-fallbacks is > 0 the client warns once per
  # provider and route that a fallback served the route, so the protocol and
  # model handling chosen for the route may not match the deployment that
  # answered. Diagnostic only; it does not change routing. Its suggested remedy,
  # pinning model_info.supported_endpoints to /v1/chat/completions, must not be
  # applied to the ChatGPT routes: see the Cloudflare challenge note above.
  # Verified 2026-09-29 on this proxy: a real /v1/responses call to `high` that fell
  # back (x-litellm-attempted-fallbacks: 3) warned exactly once for the route.
  # Do not infer tool calls from JSON text or globally strip <think>: both can
  # reinterpret legitimate model output.
  # Verified 2026-09-22 through /v1/responses on all four ChatGPT routes:
  # effort levels low/medium/high/xhigh/max succeed without fallback; minimal is rejected.
  # These aliases need explicit limits, capabilities, and zero-cost metadata:
  # LiteLLM returns null catalog fields for unknown chatgpt/* aliases, which makes
  # pi-provider-litellm label them incomplete and fail closed on reasoning control.
  openAIReasoningOverrides = {
    cache_creation_input_token_cost = 0;
    cache_read_input_token_cost = 0;
    input_cost_per_token = 0;
    max_input_tokens = 1050000;
    max_output_tokens = 128000;
    output_cost_per_token = 0;
    supported_endpoints = [ "/v1/responses" ];
    supports_high_reasoning_effort = true;
    supports_low_reasoning_effort = true;
    supports_max_reasoning_effort = true;
    supports_medium_reasoning_effort = true;
    supports_minimal_reasoning_effort = false;
    supports_none_reasoning_effort = true;
    supports_reasoning = true;
    supports_vision = true;
    supports_xhigh_reasoning_effort = true;
  };

  # LiteLLM does not infer reasoning_effort forwarding for these aliases. Keep
  # this allowlist on every primary deployment so Pi can send Responses effort.
  geminiFlashInfo = {
    max_input_tokens = 1048576;
    max_output_tokens = 65536;
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_function_calling = true;
    supports_parallel_function_calling = true;
    supports_reasoning = false;
  };

  gptOssReasoningInfo = {
    max_input_tokens = 131072;
    max_output_tokens = 65536;
    supported_endpoints = [ "/v1/chat/completions" ];
    supports_reasoning = false;
  };

  providerRegistry = {
    "free-gemini" = {
      model_info = geminiFlashInfo;
      litellm_params = {
        api_key = "os.environ/GEMINI_API_KEY";
        model = "gemini/gemini-3.6-flash";
      };
    };
    "free-ollama" = {
      model_info = gptOssReasoningInfo;
      # Ollama's OpenAI-compatible endpoint, not the native one: LiteLLM's
      # ollama adapter ignores the JSON `thinking` field on non-streaming
      # replies, so gpt-oss answers arrive with empty content.
      # https://github.com/BerriAI/litellm/issues/41962; preferred fix is
      # https://github.com/BerriAI/litellm/pull/41967. The earlier
      # https://github.com/BerriAI/litellm/issues/27956 was closed stale on a
      # premise that no longer holds. Revert to ollama/ after the fix ships
      # and passes the original non-streaming reasoning sweep.
      litellm_params = {
        api_base = "https://ollama.com/v1";
        api_key = "os.environ/OLLAMA_API_KEY";
        model = "openai/gpt-oss:120b";
        use_chat_completions_api = true;
      };
    };
    "free-openrouter" = {
      litellm_params = {
        api_key = "os.environ/OPENROUTER_API_KEY";
        model = "openrouter/openrouter/free";
      };
    };
    "high-codex" = {
      # ChatGPT deployments use Responses even when moved into a fallback tail.
      model_info = openAIReasoningOverrides;
      litellm_params = {
        allowed_openai_params = [ "reasoning_effort" ];
        model = "chatgpt/gpt-6-astra";
      };
    };
    "high-opencode" = {
      model_info = kimiK3ReasoningInfo;
      litellm_params = openCodeParams // {
        model = "openai/kimi-k3";
      };
    };
    "low-codex" = {
      model_info = openAIReasoningOverrides;
      litellm_params = {
        allowed_openai_params = [ "reasoning_effort" ];
        model = "chatgpt/gpt-6-luna";
      };
    };
    "low-deepseek" = {
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
    };
    "low-opencode" = {
      model_info = qwen38ReasoningInfo;
      litellm_params = openCodeParams // {
        model = "openai/qwen3.8-flash";
      };
    };
    "medium-codex" = {
      model_info = openAIReasoningOverrides;
      litellm_params = {
        allowed_openai_params = [ "reasoning_effort" ];
        model = "chatgpt/gpt-6.1-sol";
      };
    };
    "medium-opencode" = {
      model_info = qwen38ReasoningInfo;
      litellm_params = openCodeParams // {
        model = "openai/qwen3.8-max";
      };
    };
  };

  expand =
    seen: name:
    if lib.elem name seen then
      throw "LiteLLM route cycle: ${lib.concatStringsSep " -> " (seen ++ [ name ])}"
    else if builtins.hasAttr name routeChains then
      let
        chain = routeChains.${name};
      in
      if chain == [ ] then
        throw "LiteLLM route ${name} is empty"
      else
        lib.concatMap (expand (seen ++ [ name ])) chain
    else if builtins.hasAttr name providerRegistry then
      [ name ]
    else
      throw "Unknown LiteLLM provider or route: ${name}";

  resolvedRoutes = lib.mapAttrs (name: _: expand [ ] name) routeChains;
  deployment = name: providerRegistry.${name} // { model_name = name; };
  publicRoute = name: chain: providerRegistry.${builtins.head chain} // { model_name = name; };

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

    port = lib.mkOption {
      default = 4000;
      description = "Port for the LiteLLM service to listen on.";
      type = lib.types.port;
    };

    headroom = {
      enable = lib.mkEnableOption "Headroom context compression service";
      image = lib.mkOption {
        default = "ghcr.io/headroomlabs-ai/headroom:0.37.0@sha256:4e559273659ebc5ce8711a60278e288550fa596377af18a7058e10036d63ef0b";
        type = lib.types.str;
      };
      uid = lib.mkOption {
        default = 1000;
        description = "UID mapping for the nonroot user in the Headroom container.";
        type = lib.types.int;
      };
      gid = lib.mkOption {
        default = 1000;
        description = "GID mapping for the nonroot user in the Headroom container.";
        type = lib.types.int;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.litellm = {
      enable = true;
      inherit (cfg) environmentFile package port;
      environment = {
        CHATGPT_AUTH_FILE = "auth.json";
        CHATGPT_TOKEN_DIR = "/var/lib/litellm/chatgpt";
      };
      settings = {
        litellm_settings = {
          drop_params = true;
          # Chains cross model families, so a 200 here does not mean the route is
          # healthy: probe individual routes with `disable_fallbacks: true` or a
          # broken primary stays hidden behind whichever target answers. Inspect
          # x-litellm-attempted-fallbacks, x-litellm-model-group and
          # x-litellm-model-name to identify the deployment that actually served.
          # pi-provider-litellm cannot discover this graph from /model/info.
          # `free-opencode` is deliberately absent: opencode.ai/zen/v1 answers 403
          # FreeTierError ("can only be used from within OpenCode") on every call.
          fallbacks = lib.mapAttrsToList (name: chain: { ${name} = builtins.tail chain; }) (
            lib.filterAttrs (_: chain: builtins.tail chain != [ ]) resolvedRoutes
          );
          # Deliberately no `"*"` wildcard: a generic fallback resolves for every
          # intermediate hop too, so high-opencode failing jumped straight to
          # free-ollama and low-deepseek/free were never tried. Verified 2026-09-22
          # on 1.100.1: without the wildcard the outer loop advances the full chain.
          # Do not re-add it. Route-level truth comes from x-litellm-model-group.
        };
        model_list =
          (map deployment (builtins.attrNames providerRegistry))
          ++ (lib.mapAttrsToList publicRoute resolvedRoutes);
        router_settings = {
          # allowed_fails = 1 with one deployment per model_name means two failures
          # cool the route, and later requests report "No deployments
          # available, try again in 5 seconds" instead of the real upstream error.
          # Space probes out when diagnosing, or read only the first error.
          # https://github.com/BerriAI/litellm/issues/40405
          # https://github.com/BerriAI/litellm/issues/40130
          allowed_fails = 1;
          num_retries = 0;
        };
      };
    };

    systemd = {
      services.litellm.serviceConfig.TimeoutStopSec = "10s";
      tmpfiles.rules = lib.optionals cfg.headroom.enable [
        "d /var/lib/headroom 0700 ${toString cfg.headroom.uid}${toString cfg.headroom.gid} -"
      ];
    };

    virtualisation = lib.mkIf cfg.headroom.enable {
      docker.enable = lib.mkDefault true;
      oci-containers = {
        backend = lib.mkDefault "docker";
        containers.headroom = {
          inherit (cfg.headroom) image;
          autoStart = true;
          user = "${toString cfg.headroom.uid}:${toString cfg.headroom.gid}";
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
