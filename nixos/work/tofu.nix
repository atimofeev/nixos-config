{ pkgs, config, vars, ... }:
let tflint-w-plugins = pkgs.tflint.withPlugins (p: [ p.tflint-ruleset-aws ]);
in {
  environment.systemPackages = (with pkgs; [
    # terraform
    opentofu

    # import tools
    terraformer
    cf-terraforming

    # misc
    tenv # https://github.com/tofuutils/tenv-nix#usage
    tftui
  ]) ++ [ tflint-w-plugins ];

  # NOTE: small guide on terraformer
  # Download provider archive: https://releases.hashicorp.com/terraform-provider-aws/5.53.0/terraform-provider-aws_5.53.0_linux_amd64.zip 
  # Unarchive and put binary into: ~/.terraform.d/plugins/linux_amd64/
  # Launch: terraformer plan aws --resources=cloudfront --regions=eu-central-1 --profile=""
  # cd ${resource_folder}; t init; t plan; t apply

  sops.secrets = {
    "work/env/TF_HTTP_PASSWORD".owner = vars.username;
    "work/env/AWS_ACCESS_KEY_ID".owner = vars.username;
    "work/env/AWS_SECRET_ACCESS_KEY".owner = vars.username;
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
  '';

}
