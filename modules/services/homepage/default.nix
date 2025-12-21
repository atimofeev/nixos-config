{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.homepage;
in
{

  imports = [
    ./bookmarks.nix
    ./integrations.nix
    ./widgets.nix
  ];

  options.custom.services.homepage = {
    enable = lib.mkEnableOption "homepage bundle";
    background_image = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
    };
    listenPort = lib.mkOption {
      default = 8888;
      type = lib.types.int;
    };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."work/homepage-env" = {
      owner = config.custom.hm-admin;
      restartUnits = [ "homepage-dashboard.service" ];
    };

    services.homepage-dashboard = {
      enable = true;
      package =
        if cfg.background_image != null then
          pkgs.homepage-dashboard.overrideAttrs (oldAttrs: {
            postInstall = (oldAttrs.postInstall or "") + ''
              mkdir -p $out/share/homepage/public/images
              ln -s ${cfg.background_image} $out/share/homepage/public/images/${builtins.baseNameOf cfg.background_image}
            '';
          })
        else
          pkgs.homepage-dashboard;
      environmentFile = config.sops.secrets."work/homepage-env".path;
      inherit (cfg) listenPort;

      settings = {
        title = "${config.custom.hm-admin} dashboard";
        cardBlur = "sm";
        color = "slate";
        hideVersion = true;
        target = "_self";
        theme = "dark";
      }
      // lib.optionalAttrs (cfg.background_image != null) {
        background = {
          image = "images/${builtins.baseNameOf cfg.background_image}";
          # blur = "sm";
          saturate = 50;
          brightness = 85;
          opacity = 50;
        };
      };
    };
  };

}
