{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.vicinae;
  launcher = config.custom-hm.user.launcher.app;
in
{

  options.custom-hm.services.vicinae = {
    enable = lib.mkEnableOption "vicinae bundle";
    package = lib.mkPackageOption pkgs "vicinae" { };
    command = lib.mkOption {
      default = "vicinae toggle";
      type = lib.types.str;
    };
  };

  config = lib.mkIf (launcher == "vicinae" || cfg.enable) {

    programs.vicinae = {
      enable = true;
      inherit (cfg) package;
      systemd.enable = true;
      extensions = [
        (config.lib.vicinae.mkRayCastExtension {
          name = "gif-search";
          sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
          rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
        })
        # NOTE: won't build
        # https://github.com/nix-community/home-manager/issues/8262
        # (config.lib.vicinae.mkRayCastExtension {
        #   name = "air-quality";
        #   sha256 = "sha256-vjMGvr/YP/FYfsL6LnICMXNuhbhNbzDtePka7pPCcXM=";
        #   rev = "fc54e0d0e82a3aaec0983dd4be128ce935acdbf0";
        # })
        # (config.lib.vicinae.mkRayCastExtension {
        #   name = "bitwarden";
        #   sha256 = "sha256-N1zAPZJmmfvSw425MQDopSm/stu1IRI2t17xo8Ml+8g=";
        #   rev = "b8c8fcd7ebd441a5452b396923f2a40e879565ba";
        # })
        # (config.lib.vicinae.mkRayCastExtension {
        #   name = "catppuccin";
        #   sha256 = "sha256-mR1jpp1PAVae2P5PB+cr4jbYF47EEtdj6koKRRnU7wo=";
        #   rev = "f8ee7250696ef4ba4b7f20804bb3ea99dff24aab";
        # })
        # (config.lib.vicinae.mkRayCastExtension {
        #   name = "weather";
        #   sha256 = "sha256-GopBV/7AiOTUYdz3anWcL2gd9dDg+6tgO4wckO4ATRs=";
        #   rev = "542ed079c2eb5a95df0835d83ab1f1c2b1970e44";
        # })
      ];

    };

  };

}
