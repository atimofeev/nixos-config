{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.custom.services.ollama;

  openwebuiDefaultEnv = {
    OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString config.services.ollama.port}";
    # Disable authentication and telemetry
    WEBUI_AUTH = "False";
    ANONYMIZED_TELEMETRY = "False";
    DO_NOT_TRACK = "True";
    SCARF_NO_ANALYTICS = "True";
    LOCAL_FILES_ONLY = "False";
    USER_AGENT = "${config.custom.hm-admin}";
  };

in
{
  options.custom.services.ollama = {
    enable = lib.mkEnableOption "ollama bundle";
    package = lib.mkPackageOption pkgs "ollama" { };
    environment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Extra environment variables merged on top of Ollama defaults.";
    };
    open-webui = {
      enable = lib.mkEnableOption "Enable Open WebUI";
      package = lib.mkPackageOption pkgs "open-webui" { };
      environment = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        description = "Extra environment variables merged on top of Open-WebUI defaults.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.${config.custom.hm-admin}.extraGroups = [ "ollama" ];

    hardware.nvidia-container-toolkit.enable = true;

    services = {

      ollama = {
        enable = true;
        inherit (cfg) package;
        acceleration = "cuda";
        user = "ollama";
        environmentVariables = cfg.environment;
      };

      open-webui = {
        inherit (cfg.open-webui) enable package;
        environment = lib.recursiveUpdate openwebuiDefaultEnv cfg.open-webui.environment;
      };

    };

  };
}
