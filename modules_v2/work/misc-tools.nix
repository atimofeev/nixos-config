{
  config,
  lib,
  pkgs,
  vars,
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

      awscli2
      cloudlens
      dig
      lazysql
      nettools
      pgcli
      pwgen
      vault
      vault-kv-mv

      slack
      zoom-us
    ];

    sops.secrets."work/aws-creds" = {
      owner = vars.username;
      path = "/home/${vars.username}/.aws/credentials";
    };
  };

}
