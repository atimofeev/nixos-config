{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.ollama;
in
{
  options.custom.services.ollama = {
    enable = lib.mkEnableOption "ollama bundle";
    package = lib.mkPackageOption pkgs "ollama" { };
  };

  config = lib.mkIf cfg.enable {

    users.users.${config.custom.hm-admin}.extraGroups = [ "ollama" ];

    services = {

      ollama = {
        enable = true;
        inherit (cfg) package;
        acceleration = "cuda";
        user = "ollama";

        environmentVariables = {
          # General & NVIDIA tuning
          # OLLAMA_CONTEXT_LENGTH = "16384";
          OLLAMA_CONTEXT_LENGTH = "65536";
          OLLAMA_SCHED_SPREAD = "1";
          OLLAMA_MAX_LOADED_MODELS = "2";
          OLLAMA_NUM_PARALLEL = "2";
          OLLAMA_NUM_GPU = "999"; # Forces all layers to offload to the GPU
          OLLAMA_GPU_OVERHEAD = "1";
          OLLAMA_DEBUG = "1";
        };
      };

      open-webui = {
        enable = true;
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString config.services.ollama.port}";
          # Disable authentication and telemetry
          WEBUI_AUTH = "False";
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
          LOCAL_FILES_ONLY = "False";
          USER_AGENT = "${config.custom.hm-admin}";
        };
      };

    };

  };
}
