{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.scx;
in
{

  options.custom.services.scx = {
    enable = lib.mkEnableOption "sched_ext scheduler (scx)";

    scheduler = lib.mkOption {
      type = lib.types.str;
      default = "scx_rustland";
      description = "scx scheduler name (scx_rustland, scx_lavd, scx_bpfland, ...)";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments passed to the scx scheduler";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.scx.full;
      description = "scx package set (default: scx.full).";
    };
  };

  config = lib.mkIf cfg.enable {

    services.scx = {
      enable = true;
      inherit (cfg) scheduler extraArgs package;
    };

  };
}
