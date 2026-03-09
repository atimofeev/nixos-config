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

    home-manager.users.${config.custom.hm-admin} = {

      home.file = {

        ".terraform.d/plugins/.keep".text = ""; # create and keep this dir

        ".tofurc" = {
          target = ".tofurc";
          text = # hcl
            ''
              plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
            '';
        };

      };

      custom-hm.user.shellAliases = {
        t = "tofu";
      };

    };

  };

}
