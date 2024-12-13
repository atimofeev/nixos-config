{ pkgs, config, vars, ... }:
let tflint-w-plugins = pkgs.tflint.withPlugins (p: [ p.tflint-ruleset-aws ]);
in {
  environment.systemPackages = [ tflint-w-plugins ] ++ (with pkgs; [
    opentofu

    # import tools
    terraformer
    cf-terraforming

    # misc
    tenv # https://github.com/tofuutils/tenv-nix#usage
    tftui
  ]);

  sops.secrets = {
    "work/env/TF_HTTP_PASSWORD".owner = vars.username;
    "work/env/AWS_ACCESS_KEY_ID".owner = vars.username;
    "work/env/AWS_SECRET_ACCESS_KEY".owner = vars.username;
    "work/env/CLOUDFLARE_API_TOKEN".owner = vars.username;
    "work/env/GITLAB_TOKEN".owner = vars.username;
  };

  environment.shellInit = ''
    export TF_HTTP_PASSWORD="$(cat ${
      config.sops.secrets."work/env/TF_HTTP_PASSWORD".path
    })"
    export AWS_ACCESS_KEY_ID="$(cat ${
      config.sops.secrets."work/env/AWS_ACCESS_KEY_ID".path
    })"
    export AWS_SECRET_ACCESS_KEY="$(cat ${
      config.sops.secrets."work/env/AWS_SECRET_ACCESS_KEY".path
    })"
    export CLOUDFLARE_API_TOKEN="$(cat ${
      config.sops.secrets."work/env/CLOUDFLARE_API_TOKEN".path
    })"
    export GITLAB_TOKEN="$(cat ${
      config.sops.secrets."work/env/GITLAB_TOKEN".path
    })"
  '';

}
