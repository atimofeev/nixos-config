{
  pkgs,
  config,
  vars,
  ...
}:
let
  tflint-w-plugins = pkgs.tflint.withPlugins (p: [ p.tflint-ruleset-aws ]);
in
{
  environment.systemPackages =
    [ tflint-w-plugins ]
    ++ (with pkgs; [
      unstable.opentofu

      # import tools
      terraformer
      cf-terraforming

      # misc
      tenv # https://github.com/tofuutils/tenv-nix#usage
      # FIX: fails to build on 25.05
      # tftui
    ]);

  sops.secrets = {
    "work/env/TF_HTTP_PASSWORD".owner = vars.username;
    "work/env/CLOUDFLARE_API_TOKEN".owner = vars.username;
    "work/env/GITLAB_TOKEN".owner = vars.username;
  };

  environment.shellInit = ''
    export TF_HTTP_PASSWORD="$(cat ${config.sops.secrets."work/env/TF_HTTP_PASSWORD".path})"
    export CLOUDFLARE_API_TOKEN="$(cat ${config.sops.secrets."work/env/CLOUDFLARE_API_TOKEN".path})"
    export GITLAB_TOKEN="$(cat ${config.sops.secrets."work/env/GITLAB_TOKEN".path})"
  '';

}
