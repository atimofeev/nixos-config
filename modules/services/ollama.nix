# TODO: cleanup exessive config
{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.custom.services.ollama;

  additionalPackages = [
    pkgs.sycl-info
    pkgs.opensycl
    pkgs.level-zero
    pkgs.mkl
    pkgs.vpl-gpu-rt
    pkgs.intel-compute-runtime.drivers
    pkgs.intel-compute-runtime.out
    pkgs.intel-gpu-tools
    pkgs.intel-media-driver
    pkgs.intel-vaapi-driver
    pkgs.vaapi-intel-hybrid
    pkgs.intel-gmmlib
    pkgs.intel-ocl
    pkgs.libgcc.libgcc
    pkgs.libgcc.lib
    pkgs.libgcc.out
    # pkgs.zluda
  ];
in
{
  options.custom.services.ollama = {
    enable = lib.mkEnableOption "ollama bundle";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        ollama
        ollama-cuda
        aichat
      ])
      ++ additionalPackages;

    users.users.${config.custom.hm-admin}.extraGroups = [ "ollama" ];

    services = {

      # NOTE: ollama models: https://ollama.com/library
      ollama = {
        enable = true;
        acceleration = "cuda";
        package = pkgs.ollama-cuda;
        user = "ollama";
        environmentVariables = {
          HIP_VISIBLE_DEVICES = "0,1";
          OLLAMA_INTEL_GPU = "1";
          OLLAMA_SCHED_SPREAD = "1";
          OLLAMA_MAX_LOADED_MODELS = "2";
          OLLAMA_NUM_PARALLEL = "2";
          OLLAMA_NUM_GPU = "999";
          OLLAMA_GPU_OVERHEAD = "1";
          OLLAMA_DEBUG = "1";
          CUDA_PATH = "${pkgs.lib.makeLibraryPath [
            pkgs.cudaPackages.cudatoolkit
            pkgs.cudaPackages.cuda_cudart
          ]}";
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath additionalPackages}:$LD_LIBRARY_PATH";
        };
      };

      open-webui = {
        enable = true;
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString config.services.ollama.port}";
          # Disable authentication
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
