{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.misc-tools;
in
{

  options.custom.work.misc-tools = {
    enable = lib.mkEnableOption "misc-tools bundle";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      python3
      ruby

      awscli2
      cloudlens
      dig
      lazysql
      nettools
      pgcli
      pwgen
      ssm-session-manager-plugin
      vault
      vault-kv-mv

      slack
      zoom-us
    ];

    sops.secrets = {

      "work/aws/credentials" = {
        owner = config.custom.hm-admin;
        path = "/home/${config.custom.hm-admin}/.aws/credentials";
      };

      "work/aws/config" = {
        owner = config.custom.hm-admin;
        path = "/home/${config.custom.hm-admin}/.aws/config";
      };

    };

  };

}
