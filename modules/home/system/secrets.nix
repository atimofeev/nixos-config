{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.custom-hm.system.sops;
  home = config.home.homeDirectory;
in
{

  config = lib.mkIf cfg.enable {

    programs = {
      hyprpanel.settings.menus.clock.weather.key = config.sops.secrets."personal/weather-api".path;
      spotify-player.settings.client_id_command = "cat ${
        config.sops.secrets."personal/spotify-client-id".path
      }";
      ssh.includes = [ config.sops.secrets."work/ssh-config".path ];
    };

    sops.secrets = {
      "personal/spotify-client-id" = { };
      "personal/ssh_keys/id_ed25519_sk" = {
        sopsFile = ../../../secrets + "/${osConfig.networking.hostName}.yaml";
        path = "${home}/.ssh/id_ed25519_sk";
      };
      "personal/yubico/u2f_keys" = {
        sopsFile = ../../../secrets + "/${osConfig.networking.hostName}.yaml";
        path = "${home}/.config/Yubico/u2f_keys";
      };
      "personal/weather-api" = { };
      "work/aws-config".path = "${home}/.aws/config";
      "work/gitlab-config".path = "${home}/repos/betby/.gitconfig";
      "work/ssh-config" = { };
    };

  };

}
