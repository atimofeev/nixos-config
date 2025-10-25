{
  config,
  lib,
  pkgs,
  vars,
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
      default = ../../../assets/dark-shore-upscaled.png;
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."work/homepage-env" = {
      owner = vars.username;
      restartUnits = [ "homepage-dashboard.service" ];
    };

    services.homepage-dashboard = {
      enable = true;
      package = pkgs.homepage-dashboard.overrideAttrs (_oldAttrs: {
        postInstall = ''
          mkdir -p $out/share/homepage/public/images
          ln -s ${cfg.background_image} $out/share/homepage/public/images/${builtins.baseNameOf cfg.background_image}
        '';
      });
      environmentFile = config.sops.secrets."work/homepage-env".path;
      listenPort = 8888;

      settings = {
        title = "${vars.username} dashboard";

        background = {
          image = "images/${builtins.baseNameOf cfg.background_image}";
          # blur = "sm";
          saturate = 50;
          brightness = 85;
          opacity = 50;
        };

        cardBlur = "sm";
        theme = "dark";
        color = "slate";

        target = "_self";

        hideVersion = true;
      };
    };
  };

}
