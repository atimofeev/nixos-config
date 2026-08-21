{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.dsh;

  envFile = config.sops.secrets."personal/env/coding-agents".path or "";

  wrappedPkg = cfg.package.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      wrapProgram "$out/bin/dsh" \
        --run 'if [[ -r "${envFile}" ]]; then set -a; source "${envFile}"; set +a; fi' \
        --set AWS_PROFILE "ai" \
        --set DO_NOT_TRACK 1 \
        --set DSH_HOME "${config.xdg.configHome}/dsh" \
        --set DSH_TELEMETRY_DISABLED 1 \
        --set DSH_TELEMETRY_MODE DISABLED \
        --set OTEL_SDK_DISABLED true \
        --set SHELL "${pkgs.bashInteractive}/bin/bash" \
        --set pnpm_config_store_dir "${config.xdg.dataHome}/dsh/pnpm/store" \
        --set pnpm_config_update_notifier false \
        --prefix PATH : "${
          lib.makeBinPath [
            pkgs.pnpm
          ]
        }"
    '';
  });
in
{
  options.custom-hm.applications.dsh = {
    enable = lib.mkEnableOption "dsh bundle";
    package = lib.mkPackageOption pkgs "dsh" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPkg ];
  };
}
