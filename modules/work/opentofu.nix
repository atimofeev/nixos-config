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
    ]);

  };

}
