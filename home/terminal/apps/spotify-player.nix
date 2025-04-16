{ config, ... }: {

  programs.spotify-player = {
    enable = true;
    settings = {
      # NOTE: not working
      client_id_command =
        "cat ${config.sops.secrets."personal/spotify-client-id".path}";
      liked_icon = "";
      device = {
        volume = 85;
        autoplay = true;
      };
    };
  };

  sops.secrets = {
    "personal/spotify-client-id" = { };
    "personal/spotify-creds".path =
      "${config.home.homeDirectory}/.cache/spotify-player/credentials.json";
  };

}
