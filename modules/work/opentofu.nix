{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.work.opentofu;
  tflint-w-plugins = pkgs.tflint.withPlugins (p: [ p.tflint-ruleset-aws ]);
in
{
  options.custom.work.opentofu = {
    enable = lib.mkEnableOption "OpenTofu bundle";
    package = lib.mkPackageOption pkgs "opentofu" { };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      cfg.package
      tflint-w-plugins
    ]
    ++ (with pkgs; [
      unstable.tfsort

      # import tools
      terraformer
      cf-terraforming

      # misc
      tenv # https://github.com/tofuutils/tenv-nix#usage
      unstable.tftui
    ]);

    sops.secrets = {
      "work/env/TF_HTTP_PASSWORD".owner = config.custom.hm-admin;
      "work/env/CLOUDFLARE_API_TOKEN".owner = config.custom.hm-admin;
      "work/env/GITLAB_BASE_URL".owner = config.custom.hm-admin;
      "work/env/GITLAB_TOKEN".owner = config.custom.hm-admin;
      "work/env/PASSWORK_HOST".owner = config.custom.hm-admin;
      "work/env/PASSWORK_API_KEY".owner = config.custom.hm-admin;
    };

    environment.shellInit = ''
      export TF_HTTP_PASSWORD="$(cat ${config.sops.secrets."work/env/TF_HTTP_PASSWORD".path})"
      export CLOUDFLARE_API_TOKEN="$(cat ${config.sops.secrets."work/env/CLOUDFLARE_API_TOKEN".path})"
      export GITLAB_BASE_URL="$(cat ${config.sops.secrets."work/env/GITLAB_BASE_URL".path})"
      export GITLAB_TOKEN="$(cat ${config.sops.secrets."work/env/GITLAB_TOKEN".path})"
      export PASSWORK_HOST="$(cat ${config.sops.secrets."work/env/PASSWORK_HOST".path})"
      export PASSWORK_API_KEY="$(cat ${config.sops.secrets."work/env/PASSWORK_API_KEY".path})"
    '';
  };

}
