{ pkgs, ... }:
let tflint-w-plugins = pkgs.tflint.withPlugins (p: [ p.tflint-ruleset-aws ]);
in {
  environment.systemPackages = (with pkgs; [
    terraform
    opentofu
    tenv # https://github.com/tofuutils/tenv-nix#usage
  ]) ++ [ tflint-w-plugins ];
}
