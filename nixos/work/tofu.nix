{ pkgs, ... }:
let tflint-w-plugins = pkgs.tflint.withPlugins (p: [ p.tflint-ruleset-aws ]);
in {
  environment.systemPackages = (with pkgs; [
    terraform
    opentofu
    tenv # https://github.com/tofuutils/tenv-nix#usage
    terraformer
  ]) ++ [ tflint-w-plugins ];

  # NOTE: small guide on terraformer
  # Download provider archive: https://releases.hashicorp.com/terraform-provider-aws/5.53.0/terraform-provider-aws_5.53.0_linux_amd64.zip 
  # Unarchive and put binary into: ~/.terraform.d/plugins/linux_amd64/
  # Launch: terraformer plan aws --resources=cloudfront --regions=eu-central-1 --profile=""
  # cd ${resource_folder}; t init; t plan; t apply

}
